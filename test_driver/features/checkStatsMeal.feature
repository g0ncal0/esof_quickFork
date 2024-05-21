Feature: Meal's stats check

Scenario: Meal’s stats check successful
    Given I am on the worker side of the app
    When I press the meals stats button
    And I wait 1 second
    Then I expect to be presented with the current meal stats
