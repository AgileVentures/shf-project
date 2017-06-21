# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).

require 'ffaker'
require 'rake'
require_relative 'seed_helpers'
include SeedHelper

# The test of defined? is due to the rspec file that executes the seed file
# repeatedly.  Without this, rspec complains about "already initialized constant"
SEED_STOP_MSG = '<<< SEEDING STOPPED' unless defined?(SEED_STOP_MSG)

SEED_COMPLETE_MSG = '<<< SEEDING COMPLETED' unless defined?(SEED_COMPLETE_MSG)

NUM_USERS = 100 unless defined?(NUM_USERS)

DEFAULT_PASSWORD = 'whatever' unless defined?(DEFAULT_PASSWORD)

unless Rails.env.development? || Rails.env.production? ||
    Rails.env.test? || ENV['HEROKU_STAGING']

  puts 'Unknown Rails environment !!'
  abort SEED_STOP_MSG
end

puts ">>> SEEDING ENVIRONMENT: #{Rails.env}"

puts 'Creating admin user'
if Rails.env.production?
  begin
    email = env_invalid_blank('SHF_ADMIN_EMAIL')
    pwd = env_invalid_blank('SHF_ADMIN_PWD')

    User.create!(email: email, password: pwd, admin: true)
  rescue => e
    puts e.inspect
    puts SEED_STOP_MSG
    raise
  end
else
  email = 'admin@sverigeshundforetagare.se'
  pwd = 'hundapor'
  User.create(email: email, password: pwd, admin: true)
end

if Region.all.empty?
  puts 'Loading regions'
  Rake::Task['shf:load_regions'].invoke
end

if Kommun.all.empty?
  puts 'Loading kommuns'
  Rake::Task['shf:load_kommuns'].invoke
end


if AdminOnly::MemberAppWaitingReason.all.empty?
  puts 'Loading MemberAppWaitingReasons: Creating the "Other/custom" reason'
  AdminOnly::MemberAppWaitingReason.create(name_sv: AdminOnly::MemberAppWaitingReason.other_reason_name(:sv),
                                           description_sv: AdminOnly::MemberAppWaitingReason.other_reason_desc(:sv),
                                           name_en: AdminOnly::MemberAppWaitingReason.other_reason_name(:sv),
                                           description_en: AdminOnly::MemberAppWaitingReason.other_reason_desc(:en),
                                           is_custom: false)
end


puts 'Creating business categories'
business_categories = %w(Träning Psykologi Rehab Butik Trim Friskvård Dagis Pensionat Skola)
business_categories.each { |b_category| BusinessCategory.find_or_create_by(name: b_category) }
BusinessCategory.find_or_create_by(name: 'Sociala tjänstehundar', description: 'Terapi-, vård- & skolhund dvs hundar som jobbar tillsammans med sin förare/ägare inom vård, skola och omsorg.')
BusinessCategory.find_or_create_by(name: 'Civila tjänstehundar', description: 'Assistanshundar dvs hundar som jobbar åt sin ägare som service-, signal, diabetes, PH-hund mm')

unless Rails.env.production? || Rails.env.test?

  puts 'Creating users ...'

  # Create users
  users = []
  NUM_USERS.times do
    users << User.create(email: FFaker::InternetSE.free_email,
                         password: DEFAULT_PASSWORD)
  end

  puts "Users created: #{users.length}"

  puts "\nCreating membership applications ..."
  puts "  As companies are created for accepted applications, their address has to be geocoded/located."
  puts "  This takes time to do. Be patient. (You can look at the /log/development.log to be sure that things are happening and this is not stuck.)"

  users.each { |u| SeedHelper::make_applications_for u }


  puts "\n Membership Applications by state:"
  states = MembershipApplication.aasm.states.map(&:name)
  states.sort.each do |state|
    puts "  #{state}: #{MembershipApplication.where(state: state).count }"
  end
end

puts SEED_COMPLETE_MSG
