Feature: Easy Payment

  Scenario: Successful Purchase With Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I write a valid credit card
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I write an invalid credit card
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up

  Scenario: Successful Purchase With MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I write a valid phone number
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I write an invalid phone number
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up
