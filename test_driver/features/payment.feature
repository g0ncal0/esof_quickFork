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

  Scenario: Successful Purchase With Saved Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I have a card saved
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Saved Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I do not have a card saved
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up

Scenario: Successful Purchase With Unsaved Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I write a valid card number
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Unsaved Card
    Given I am on checkout page during a purchase
    When I tap "Pay with card" button
    And  I write an invalid card number
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
    And I do not have a MbWay number saved
    And I wait 1 second
    Then I expect the unsuccessful added number pop-up

  Scenario: Successful Purchase With Saved MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I have a MbWay number saved
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Saved MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I do not Have a MbWay number saved
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up

  Scenario: Successful Purchase With Unsaved MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I write a valid number
    And I wait 1 second
    Then I expect the successful purchase pop-up

  Scenario: Unsuccessful Purchase With Unsaved MBWay
    Given I am on checkout page during a purchase
    When I tap "Pay with MBWay" button
    And  I write an invalid number
    And I wait 1 second
    Then I expect the unsuccessful purchase pop-up
