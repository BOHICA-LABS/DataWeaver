Feature: Error Handling
  As a developer
  I want DataWeaver to handle errors and ensure data integrity
  So that my data synchronization pipelines are resilient

  Scenario: Handling errors in a source connector
    Given I have a source connector
    When an error occurs during data reading
    Then DataWeaver should handle the error gracefully
    And DataWeaver should retry the operation based on the configured retry policy

  Scenario: Handling errors in a sink connector
    Given I have a sink connector
    When an error occurs during data writing
    Then DataWeaver should handle the error gracefully
    And DataWeaver should retry the operation based on the configured retry policy
