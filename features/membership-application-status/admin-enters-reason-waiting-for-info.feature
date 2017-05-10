Feature: Admin sets or enters the reason they are waiting for info from a user
  As an admin
  so that SHF can talk with the user specifically about why they are waiting and know how long they might need to wait,
  I need to set the reason why SHF is waiting
  and if the reason is not available from a list,
  I need to be able to type in text that describes the situation

  PT: https://www.pivotaltracker.com/story/show/143810729

  Background:
    Given the following users exists
      | email                 | admin |
      | emma@happymutts.se    |       |
      | hans@happymutts.se    |       |
      | anna@nosnarkybarky.se |       |
      | admin@shf.com         | true  |

    Given the following business categories exist
      | name         | description                     |
      | dog grooming | grooming dogs from head to tail |
      | dog crooning | crooning to dogs                |
      | rehab        | physcial rehabitation           |

    Given the following regions exist:
      | name         |
      | Stockholm    |

    Given the following companies exist:
      | name                 | company_number | email                 | region    |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.se | Stockholm |


    And the following applications exist:
      | first_name | user_email            | company_number | category_name | state   |
      | Emma       | emma@happymutts.se    | 5562252998     | rehab         | waiting_for_applicant |
      | Hans       | hans@happymutts.se    | 5562252998     | dog grooming  | waiting_for_applicant |
      | Anna       | anna@nosnarkybarky.se | 5560360793     | rehab         | waiting_for_applicant |

    And I am logged in as "admin@shf.com"


  Scenario: Admin selects 'need more documentation' as the reason SHF is waiting_for_applicant
    Given I am on "Emma" application page
    When I set t("<string>") to t("<string>")
    And I click on t("membership_applications.edit.submit_button_label")
    Then I should see t("membership_applications.update.success")
    And I should see t("membership_applications.accepted")



  Scenario: things go wrong
