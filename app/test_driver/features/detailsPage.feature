Feature: Home page
  Visualize the home information

  Background:
    Given I am on the "signInPageKey" page
    When I fill the "emailFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordFieldKey" field with "kikaines"
    And I tap the "signInSignUpButtonKey" button

  Scenario: View a point of interest's description page
    Given I am on the "homeScreenKey" page
    And I pause for 10 seconds
    Then I expect the widget "nearbyWidget" to be present within 20 seconds
    And I tap the "detailsListView" navbaricon
    Then I should be on the "detailsPageKey" page
