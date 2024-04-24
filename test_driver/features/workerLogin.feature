Feature: Worker Login

  Scenario: Successful Worker Login
    Given I am on profile page
    When I tap "Worker Login" button
    And I write a valid password
    Then I expect the text "Worker access granted!" to appear

  Scenario: Successful Worker Login
    Given I am on profile page
    When I tap "Worker Login" button4
    And I write a valid password
    And I wait second
    And I go to Store page
    Then I expect the text "Validador de Senhas" to appear

  Scenario: Unsuccessful Worker Login
    Given I am on profile page
    When I tap "Worker Login" button
    And I write an invalid password
    Then I expect the text "Invalid password" to appear

  Scenario: Successful Worker Login
    Given I am on profile page
    And I am logged in as worker
    When I tap "Worker Logout" button
    And I write a valid password
    Then I expect the text "Worker Logout done successfully!" to appear