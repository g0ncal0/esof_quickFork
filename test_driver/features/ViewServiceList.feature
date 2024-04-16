Feature: View Service List

   Scenario: login and access Uptime part and see Service's list
     Given I am logged in
     And I open the drawer
     And I tap the "UpTime" item
     And I tap the "servicos" button
     And I tap the "lista_servicos" button
     Then I expect the text "Lista de Serviços" to be present