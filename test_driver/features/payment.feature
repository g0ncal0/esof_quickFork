Feature: Easy Payment

  Scenario: Successful Added Card
    Given I am on the profile page
    When I tap "Add credit card"
    And I write a valid number
    And I wait 1 second
    Then I expect the successful added card pop-up

  Scenario: Unsuccessful Added Card
    Given I am on the profile page
    When I tap "Add credit card"
    And I write an invalid number
    And I wait 1 second
    Then I expect the unsuccessful added card pop-up

  Scenario: Successful Purchase With Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I verify my card
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I do not verify my card
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up

  Scenario: Successful Added Number
    Given I am on the profile page
    When I tap "Add MbWay"
    And I write a valid number
    And I wait 1 second
    Then I expect the successful added number pop-up

  Scenario: Unsuccessful Added Number
    Given I am on the profile page
    When I tap "Add MbWay"
    And I write an invalid number
    And I wait 1 second
    Then I expect the unsuccessful added number pop-up

  Scenario: Successful Purchase With MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I verify my number
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I do not verify my number
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up
