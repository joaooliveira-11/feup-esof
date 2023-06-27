Feature: User Registration

  Scenario: Successful user registration
    Given I am on the "signInPageKey" page
    And I tap the "signUpText" button
    Then I am on the "SignUpPageKey" page
    When I fill the "nameFieldKey" field with "joao"
    And I fill the "usernameFieldKey" field with "jonyp"
    And I fill the "emailSignupFieldKey" field with "jonyp1@gmail.com"
    And I fill the "passwordTextField" field with "joao1234"
    And I fill the "confirmPasswordTextField" field with "joao1234"
    When I tap the "signInSignUpButtonKey" button
    Then I should be on the "homeScreenKey" page

  Scenario: Failed user registration - Email already exists
    Given I am on the "signInPageKey" page
    And I tap the "signUpText" button
    Then I am on the "SignUpPageKey" page
    When I fill the "nameFieldKey" field with "joao"
    And I fill the "usernameFieldKey" field with "jonyp"
    And I fill the "emailSignupFieldKey" field with "kikaines@gmail.com"
    And I fill the "passwordTextField" field with "joao1234"
    And I fill the "confirmPasswordTextField" field with "joao1234"
    When I tap the "signInSignUpButtonKey" button
    Then I expect the widget "emailAlreadyInUsePopup" to be present within 20 seconds

  Scenario: Failed user registration - password not matching
    Given I am on the "signInPageKey" page
    And I tap the "signUpText" button
    Then I am on the "SignUpPageKey" page
    When I fill the "nameFieldKey" field with "joao"
    And I fill the "usernameFieldKey" field with "jonyp"
    And I fill the "emailSignupFieldKey" field with "jonyp1@gmail.com"
    And I fill the "passwordTextField" field with "joao1234"
    And I fill the "confirmPasswordTextField" field with "joao34"
    When I tap the "signInSignUpButtonKey" button
    Then I expect the widget "passwordsDoNotMatchPopup" to be present within 20 seconds

