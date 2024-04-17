Feature: View Custom Email

  Scenario: View Custom Email
    Given I am logged in
    And I open the drawer
    And I tap the "UpTime" item
    And I tap the "docentes" button
    And I tap the "lista_docentes" button
    And I tap the "teacher_item_0" item
    And I tap the "see_schedule" button
    And I tap the "schedule_meeting" button
    And I tap the "edit_email" button
    Then I expect the text "E-mail Personalizado" to be present