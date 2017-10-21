class PaymentsController < ApplicationController
  require 'hips'

  protect_from_forgery except: :webhook

  def create
    payment_type = params[:type]
    user_id = params[:user_id]

    @payment = Payment.create(payment_type: payment_type,
                              user_id: user_id,
                              status: Payment.order_to_payment_status(nil))

    success_url = payment_success_url(user_id: user_id, id: @payment.id)
    error_url   = payment_error_url(user_id: user_id, id: @payment.id)

    webhook_url = (SHF_WEBHOOK_HOST || root_url) +
                  payment_webhook_path.sub('/en', '')

    hips_order = HipsService.create_order(@payment.id,
                                          user_id,
                                          session.id,
                                          payment_type,
                                          success_url,
                                          error_url,
                                          webhook_url)
    @hips_id = hips_order['id']
    @payment.hips_id = @hips_id
    @payment.status = Payment.order_to_payment_status(hips_order['status'])
    @payment.save

  rescue RuntimeError, HTTParty::Error => exc
    @payment.destroy if @payment.persisted?

    log_hips_activity('create order', 'error', nil, @hips_id, exc)

    log_hips_activity('create order', 'error', nil, @hips_id, exc.cause)

    helpers.flash_message(:alert, t('.something_wrong'))

    redirect_back fallback_location: root_path
  end

  def webhook
    # This webhook will be called multiple times (7) during the order create and
    # payment process. We are only interested in the "order.successful" event,
    # which indicates successful payment.
    # Later, we can switch to "hooks/webhook_url_on_success" - which will
    # be triggered *only* by the "order.successful" event.
    # (That webhook is not available at this time (October 18, 2017)).

    payload = JSON.parse request.body.read

    return head(:ok) unless payload['event'] == 'order.successful'

    resource = HipsService.validate_webhook_origin(payload['jwt'])

    payment_id = resource['merchant_reference']['order_id']
    hips_id    = resource['id']

    payment = Payment.find(payment_id)
    payment.status = Payment.order_to_payment_status(resource['status'])
    payment.save

    log_hips_activity('Webhook', 'info', payment_id, hips_id)

  rescue RuntimeError => exc
    log_hips_activity('Webhook', 'error', payment_id, hips_id, exc)

  ensure
    head :ok
  end

  def success
    helpers.flash_message(:notice, t('.success'))
    redirect_to root_path   # Redirect to user account page (when it exists)
  end

  def error
    helpers.flash_message(:alert, t('.error'))
    redirect_to root_path   # Redirect to user account page (when it exists)
  end

  private

  def log_hips_activity(activity, severity, payment_id, hips_id, exc=nil)
    ActivityLogger.open(HIPS_LOG, 'HIPS_API', activity, false) do |log|
      log.record(severity, "Payment ID: #{payment_id}") if payment_id
      log.record(severity, "HIPS ID: #{hips_id}") if hips_id
      log.record(severity, "Exception class: #{exc.class}") if exc
      log.record(severity, "Exception message: #{exc.message}") if exc
    end
  end
end
