Given(/^the following users exist(?:s|)$/) do |table|
  table.hashes.each do |user|

    is_member = user.delete('is_member')

    if user['admin'] == 'true'
      FactoryGirl.create(:user, user)
    else
      if is_member == 'true'
        FactoryGirl.create(:member_with_membership_app, user)
      else
        if ! user['company_number'].nil?
          FactoryGirl.create(:user_with_membership_app, user, company_number: user['company_number'])
        else
          FactoryGirl.create(:user, user)
        end
      end
    end
  end
end

Given(/^I am logged in as "([^"]*)"$/) do |email|
  @user = User.find_by(email: email)
  login_as @user, scope: :user
end

Given(/^I am Logged out$/) do
  logout
end
