Feature: Easier login

    Scenario: Successful login
        Given I am on the login page
        When I press the login button referencing Sigarra
        And It redirects me to the Sigarra website
        And It requires me to login with my Sigarra credentials
        And I give a valid and/or existing account
        Then I expect to be logged in with my faculty’s account
        And be given an option to remember that login for future uses of the app

    Scenario: Unsuccessful login
        Given I am a student or worker
        When I press the login button referencing Sigarra
        And It redirects me to the Sigarra website
        And It requires me to login with my Sigarra credentials
        And I give an invalid and/or non-existing account
        Then I expect to be given an error
        And be given an option to try again