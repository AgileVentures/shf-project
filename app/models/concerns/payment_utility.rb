module PaymentUtility
  extend ActiveSupport::Concern

  included do
    # Instance methods for class which includes this module
    def most_recent_payment(payment_type)
      payments.completed.send(payment_type).order(:created_at).last
    end

    def payment_expire_date(payment_type)
      most_recent_payment(payment_type)&.expire_date
    end

    def payment_notes(payment_type)
      most_recent_payment(payment_type)&.notes
    end
  end

  class_methods do

    def next_payment_dates(entity_id, payment_type)
      # Business rules:
      # start_date = prior payment expire date + 1 day
      # expire_date = start_date + 1 year - 1 day
      # (special rules apply for remainder of 2017)
      entity = find(entity_id)

      if entity.payment_expire_date(payment_type)
        start_date = entity.most_recent_payment(payment_type).expire_date + 1.day
      else
        start_date = Date.current
      end
      if Date.today.year == 2017
        expire_date = Date.new(2018, 12, 31)
      else
        expire_date = start_date + 1.year - 1.day
      end
      [start_date, expire_date]
    end
  end
end
