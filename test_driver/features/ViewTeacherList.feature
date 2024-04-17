Feature: View Teacher List

   Scenario: login and access Uptime part and see Teacher's list
     Given I am logged in
     And I open the drawer
     And I tap the "UpTime" item
     And I tap the "docentes" button
     And I tap the "lista_docentes" button
     Then I expect the text "Lista de Docentes" to be present