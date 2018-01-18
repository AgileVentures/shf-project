Feature: As an admin
  I want to be able to edit application configuration
  Including chair signature and SHG logo images

  Background:
    Given the following users exists
      | email             | password | admin | member    | first_name | last_name |
      | admin@random.com  | password | true  | false     | emma       | admin     |

  Scenario: Admin edits application configuration
    Given I am logged in as "admin@random.com"
    And I am on the "landing" page
    Then I click on the t("menus.nav.admin.application_config") link
    And I should see t("admin_only.admin_page.edit.title")
    And I choose an SHF "admin_only_admin_page[chair_signature]" file named "signature.png" to upload
    And I choose an SHF "admin_only_admin_page[shf_logo]" file named "medlem.png" to upload
    And I click on t("submit") button
    Then I should see t("admin_only.admin_page.update.success")

  Scenario: Admin edits app configuration and tries to upload non-image file
    Given I am logged in as "admin@random.com"
    And I am on the "landing" page
    Then I click on the t("menus.nav.admin.application_config") link
    And I should see t("admin_only.admin_page.edit.title")
    And I choose an SHF "admin_only_admin_page[shf_logo]" file named "text_file.jpg" to upload
    And I click on t("submit") button
    Then I should see t("admin_only.admin_page.update.error")
