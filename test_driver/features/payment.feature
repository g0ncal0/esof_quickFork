Feature: Easy Payment

  Scenario: Successful Purchase
  Given I am on payment methods page during a purchase
  And I do not have saved payment methods
  When I try to add a payment method
  And  I write a valid card or phone number
  And I wait 1 second
  Then I expect the successful purchase pop-up
  And the ticket to be available in the ticket menu

  Scenario: Unsuccessful Purchase
  Given I am on payment methods page during a purchase
  And I do not have saved payment methods
  When I try to add a payment method
  And  I write a not valid  card or phone number
  And I wait 1 second
  Then I expect the failed purchase pop-up
  And the ticket not to be available in the ticket menu
