module MembershipApplicationsHelper

  def can_edit_state?
    policy(@membership_application).permitted_attributes_for_edit.include? :state
  end


  def member_full_name
    @membership_application ? "#{@membership_application.first_name} #{@membership_application.last_name}" : '..'

  end


  # the method to use to get the name for a reason, given the locale
  # If no locale is given, the current locale is used.
  # If the locale given isn't found or defined, the default name method is used
  def reason_name_method(locale = I18n.locale)
    reason_method 'name', locale
  end


  # the method to use to get the description for a reason, given the locale
  # If no locale is given, the current locale is used.
  # If the locale given isn't found or defined, the default name method is used
  def reason_desc_method(locale = I18n.locale)
    reason_method 'description', locale
  end


  # a collection of arrays with [the name of the reasons for waiting, the reason (object)]
  # in the locale
  def reasons_for_waiting_names(use_locale = I18n.locale)
    reasons_for_waiting_info('name', use_locale)
  end


  # a collection of arrays with [the descriptions of the reasons for waiting,  the reason (object)]
  # in the locale
  def reasons_for_waiting_descs(use_locale = I18n.locale)
    reasons_for_waiting_info('description', use_locale)
  end


  private

  def reason_method(method_prefix, locale)
    possible_method = "#{method_prefix}_#{locale}".to_sym
    method_name = (AdminOnly::MemberAppWaitingReason.new.respond_to?(possible_method) ? possible_method : AdminOnly::MemberAppWaitingReason.send("default_#{method_prefix}_method".to_sym))
  end


  def reasons_for_waiting_info(method_prefix, locale)
    method_name = reason_method(method_prefix, locale)
    AdminOnly::MemberAppWaitingReason.all.map { |r| [r.id, r.send(method_name)] }
  end

end
