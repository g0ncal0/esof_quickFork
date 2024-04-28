Feature: In-app validation of tickets

  Scenario: Successful validation
    Given I am on the worker side of the app
    When I press the scan functionality
    And I point It in the direction of the ticket’s QR code
    And It is fully inside camera boundaries
    Then I expect to successfully scan said ticket
    And validate It immediately on the app


  Scenario: Unsuccessful validation
    Given I am on the worker side of the app
    When I press the scan functionality
    And I point It in the direction of the ticket’s QR code
    And It is wrongfully directed and/or there are parts of the code badly shown or recognizable
    Then I expect to receive an error message informing me that a scan was not possible to be made
    And the opportunity to try again