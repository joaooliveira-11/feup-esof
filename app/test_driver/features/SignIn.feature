Feature: User Login

  Scenario: Successful user login
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    When I tap the "signInSignUpButtonKey" button
    Then I should be on the "homeScreenKey" page

  Scenario: Failed user login - Invalid credentials
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kika@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    And I tap the "signInSignUpButtonKey" button
    Then I expect the widget "userNotFoundPopupKey" to be present within 20 seconds

  Scenario: Failed user login - Password Wrong
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kika1234"
    When I tap the "signInSignUpButtonKey" button
    Then I expect the widget "wrongPasswordPopupKey" to be present within 20 seconds

