Feature: Accounts

  Scenario: New user gets desperate
    When I go to the home page
    And I fill in "18004688487" as my phone number
    And I press the sign up button
    Then I get a text with my secret code
    And the secret code field is empty
    When I fill in my secret code
    And I fill in the date of birth with "December 31, 1977"
    And I fill in my name as "Mike"
    And I fill in my description as "black shirt, glasses, math book"
    And I check my gender as male
    And I fill in the minimum age with "21"
    And I fill in the maximum age with "34"
    And I check my desired gender as female
    And I submit my profile
    Then I see a description of how to use the Web site
    And "18004688487" is confirmed

  Scenario: New user fails to enter the proper secret code
    When I go to the home page
    And I fill in "8004688487" as my phone number
    And I press the sign up button
    Then I get a text with my secret code
    When I fill in "this is not a love song" as my secret code
    And I submit my profile
    Then I see no description of how to use the Web site
    And "18004688487" is unconfirmed
    And I see the error "doesn't match" on the secret code field

  Scenario: New user must enter valid form stuff

  @wip @later
  Scenario: Secret code reminder
    Given I am confirmed as "8004688487"
    When I go to the home page
    And I follow the link to resend my secret code
    And I press the button to resend my secret code
    Then I get a response telling me about my new secret key
    When I go to the home page
    And I follow the sign in link
    And i fill in my phone number as "8004688487"
    And I fill in my secret key

  Scenario: We strip all non-digits from phone number when you sign up
    When I go to the home page
    And I fill in "(800) 468-84 87" as my phone number
    And I press the sign up button
    Then a user has a phone number of "18004688487"
