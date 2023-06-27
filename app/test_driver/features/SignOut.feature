Feature: User Logout

  Background:
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    And I tap the "signInSignUpButtonKey" button
    And I am on the "homeScreenKey" page
    Then I pause for 10 seconds
    And I tap the "profileButtonKey" navbaricon

  Scenario: Successful User logout
    Given I am on the "profileScreen" page
    When I tap the "signOutButton" button
    And I pause for 10 seconds
    Then I should be on the "signInPageKey" page
