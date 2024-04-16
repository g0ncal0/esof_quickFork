Feature: View Service Page

   Scenario: login and access Uptime part and see Service's page
     Given I am logged in
     And I open the drawer
     And I tap the "UpTime" item
     And I tap the "servicos" button
     And I tap the "lista_servicos" button
     And I tap the "item_1" item
     Then I expect the text "Bar da Biblioteca" to be present
     