Feature: Profile information page
  Visualize the user profile information

  Background:
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    And I tap the "signInSignUpButtonKey" button

  Scenario: Access the profile information page
    Given I am on the "homeScreenKey" page
    Then I pause for 20 seconds
    And I tap the "profileButtonKey" navbaricon
    And I should be on the "profileScreen" page

  Scenario: View profile information page
    Given I am on the "homeScreenKey" page
    Then I pause for 10 seconds
    And I tap the "profileButtonKey" navbaricon
    Then I pause for 10 seconds
    Then I expect the text "Visited" to be present
    And I expect the text "Activity" to be present

  Scenario: View visited points of interest
    Given I am on the "homeScreenKey" page
    Then I pause for 10 seconds
    And I tap the "profileButtonKey" navbaricon
    And I tap the "visitedTabKey" navbaricon
    Then I expect the widget "visitedWidgetKey" to be present within 20 seconds

  Scenario: View the number of points of interest
    Given I am on the "homeScreenKey" page
    Then I pause for 10 seconds
    And I tap the "profileButtonKey" navbaricon
    Then I expect the widget "nrVisitedPointsText" to be present within 20 seconds