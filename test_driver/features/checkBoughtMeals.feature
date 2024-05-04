Feature: Consult bought meals

  Scenario: Successful Consult of Next Ticket
    Given I am on the Checkout page
    When I buy the meal
    And I go to the Bought Meals menu
    And I tap the "See More" button
    And I scroll down
    Then the button of the meal I bought should appear

  Scenario: Successful Consult of Next Ticket
    Given I am on the Main Menu
    And I have bought the next meal ticket
    When I select the Bought Meals Menu
    Then the button with text "Next Meal Ticket" should appear

  Scenario: Successful Consult of Next Ticket
    Given I am on the Bought Meals Menu
    And I have bought the next meal ticket
    When I tap "Next Meal Ticket" button
    And I wait 1 second
    Then a QRCode should appear

  Scenario: Unsuccessful Consult of Next Ticket
    Given I am on the Main Menu
    And I have not bought the next meal ticket
    When I select the Bought Meals Menu
    Then the text "You don't have a ticket for the next meal" should appear
