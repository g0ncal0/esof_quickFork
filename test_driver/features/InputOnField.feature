Feature: Input on Field

    Scenario: login and access Uptime part and search for a teacher
        Given I am logged in
        And I open the drawer
        And I tap the "UpTime" item
        And I tap the "docentes" button
        And I tap the "pesquisa_docentes" button
        And I fill the "search_bar" field with "Bruno Lima"
        Then I expect the text "Bruno Lima" to be present
