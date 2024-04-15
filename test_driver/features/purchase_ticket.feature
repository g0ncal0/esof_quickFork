Feature: Buy Tickets

  Scenario: Successful Purchase
    Given I am on the store page
    And I have money on the account
    When I select a day
    And a type of meal
    And  I tap the “Buy” button
    And I wait 1 second
    Then I expect the QR code to appear
    And the ticket is in the ticket menu

  Scenario: Unsuccessful Purchase
    Given I am on the store page
    And I do not have money on the account
    When I select a day
    And a type of meal
    And  I tap the “Buy” button
    And I wait 1 second
    Then I expect a failed purchase screen
    And the ticket not to be present