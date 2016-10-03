@mobile @native @login
Feature: Login feature

  Scenario: As a valid user I can log into my app
    When I enter login credentials
    When I press "Login"
#    Then I see "Welcome to coolest app ever"
    Then I wait for "Invalid credentials, try again" to appear