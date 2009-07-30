Feature: Queries couchdb
  In order to manage documents in couchdb
  As a developer
  I want to create, read, update and delete documents
  
  Scenario: List all document
    Given I have a couchdb connexion
    And a Bill mapper
    And two created bills
    When I call all bills
    Then I should see 2 bills
  
  

  
