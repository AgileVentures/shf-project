require_relative File.join('..', 'services', 'address_exporter')


class ShfApplication < ApplicationRecord

  before_destroy :before_destroy_checks
  after_destroy  :after_destroy_checks

  belongs_to :user

  #  A Company for a membership application (an instantiated one)
  #  is created (instantiated) only when a membership is *accepted* --
  #  unless the company already exists, in which case that existing instance
  #  is associated with a membership application.
  #  See the 'accept_membership' method below; note the .find_or_create method
  #
  #  Until a membership application is accepted, we just keep the
  #  company_number.  That's what we'll later use to create (instantiate)
  #  a company if/when needed.
  #
  has_and_belongs_to_many :companies

  has_and_belongs_to_many :business_categories
  has_many :uploaded_files

  belongs_to :waiting_reason, optional: true,
             foreign_key: "member_app_waiting_reasons_id",
             class_name: 'AdminOnly::MemberAppWaitingReason'


  validates_presence_of :company_number,
                        :contact_email,
                        :state

  validates_length_of :company_number, is: 10
  validates_format_of :contact_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: [:create, :update]
  validates_uniqueness_of :user_id, scope: :company_number
  validate :swedish_organisationsnummer

  accepts_nested_attributes_for :uploaded_files, allow_destroy: true
  accepts_nested_attributes_for :user, update_only: true

  scope :open, -> { where.not(state: [:accepted, :rejected]) }

  delegate :full_name, to: :user, prefix: true
  delegate :membership_number, :membership_number=, to: :user, prefix: false

  include AASM

  aasm :column => 'state' do

    state :new, :initial => true
    state :under_review
    state :waiting_for_applicant
    state :ready_for_review
    state :accepted
    state :rejected


    event :start_review do
      transitions from: :new, to: :under_review
      transitions from: :ready_for_review, to: :under_review
    end

    event :ask_applicant_for_info do
      transitions from: :under_review, to: :waiting_for_applicant
    end

    event :cancel_waiting_for_applicant do
      transitions from: :waiting_for_applicant, to: :under_review
    end

    event :is_ready_for_review do
      transitions from: :waiting_for_applicant, to: :ready_for_review
    end

    event :accept do
      transitions from: [:under_review, :rejected], to: :accepted, after: :accept_membership
    end

    event :reject do
      transitions from: [:under_review, :accepted], to: :rejected, after: :reject_membership
    end

  end

  # these are only used by the submisssion form and are not saved to the db
  def marked_ready_for_review
    @marked_ready_for_review ||= (ready_for_review? ? 1 : 0)
  end


  def marked_ready_for_review=(value)
    @marked_ready_for_review = value
  end


  def swedish_organisationsnummer
    errors.add(:company_number, :invalid, company_number: self.company_number) unless errors.include?(:company_number) || Orgnummer.new(self.company_number).valid?
  end


  def not_a_member?
    !user.member?
  end


  def accept_membership
    begin

      company = Company.find_or_create_by!(company_number: company_number) do |co|
        co.email = contact_email
      end

      update(company: company)

      # email the applicant to let them know the application was approved:
      ShfApplicationMailer.app_approved(self).deliver_now

    rescue => e
      puts "ERROR: could not accept_membership.  error: #{e.inspect}"
      raise e
    end
  end


  def reject_membership
    user.update(membership_number: nil)
    destroy_uploaded_files
  end


  def before_destroy_checks

    destroy_uploaded_files

  end

  def after_destroy_checks
    # if this was the only application associated with a company, destroy the company
    unless companies.empty?
      companies.each do |company|
        company.shf_applications.reload
        company.destroy if (company.shf_applications.count == 0)
      end
    end
  end

  def se_mailing_csv_str
     company.nil? ?  AddressExporter.se_mailing_csv_str(nil) : company.se_mailing_csv_str
  end


  private

  def destroy_uploaded_files

    uploaded_files.each do |uploaded_file|
      uploaded_file.actual_file = nil
      uploaded_file.destroy
    end

    save
  end


end
