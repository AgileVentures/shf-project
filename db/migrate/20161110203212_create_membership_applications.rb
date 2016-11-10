class CreateMembershipApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :membership_applications do |t|
      t.string :company_name
      t.integer :company_number, limit: 8
      t.string :contact_person
      t.string :phone_number
      t.string :company_email

      t.timestamps
    end
  end
end
