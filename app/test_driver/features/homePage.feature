Feature: Home page
  Visualize the home information

  Background:
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    And I tap the "signInSignUpButtonKey" button

  Scenario: Get suggestions about the nearby points
    Given I am on the "homeScreenKey" page
    And I pause for 10 seconds
    Then I expect the widget "nearbyWidget" to be present within 40 seconds

  Scenario: Get suggestions about the recommended points
    Given I am on the "homeScreenKey" page
    And I pause for 10 seconds
    Then I expect the widget "recommendedWidget" to be present within 40 seconds