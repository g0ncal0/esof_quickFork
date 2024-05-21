Feature: Sigarra User Information Extraction

  Scenario: Sigarra User Information Showing On Homepage
    Given I am on the home page
    Then I expect to see my Sigarra profile picture in the upper right corner
    And I expect to see my first name on the home page

  Scenario: Sigarra Profile Picture Showing On Profile Page
    Given I am on the profile page
    Then I expect to see my Sigarra profile picture