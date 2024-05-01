Feature: Ticket Creation

  Scenario: Create QR Code
    Given I am on checkout page after a purchase
    When I go to tickets page
    Then I expect a button to appear

  Scenario: View QR Code
    Given I am on checkout page after a purchase
    When I go to tickets page
    And I tap the first button
    Then I expect a QR Code to appear