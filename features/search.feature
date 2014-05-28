Feature: Search 

  Background: 
    Given a post about "Searching with Sphinx"
      And assuming the Sphinx index is up to date
      And I am on the homepage

 @wip
  Scenario: A visitor searches for posts by title
    When I search for "Sphinx"
      Then I should see a post about "Searching with Sphinx"

  Scenario: A visitor fuzzy searches for posts by title
    When I search for "arch"
      Then I should see a post about "Searching with Sphinx"
