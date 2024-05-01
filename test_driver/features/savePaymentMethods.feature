Feature: Save Payment Methods

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

  Scenario: Successful Purchase With Saved MBWay
    Given I am on checkout page during a purchase
    And  I have a valid MbWay number saved
    When I tap "Pay with MBWay" button
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Saved MBWay
    Given I am on checkout page during a purchase
    And  I don´t have a valid MbWay number saved
    When I tap "Pay with MBWay" button
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up
