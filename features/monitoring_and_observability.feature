Feature: Monitoring and Observability
  As a developer
  I want to monitor the health and performance of data synchronization pipelines
  So that I can identify and resolve issues quickly

  Scenario: Monitoring pipeline health
    Given I have a data synchronization pipeline
    When I enable monitoring in DataWeaver
    Then DataWeaver should provide metrics and logs for the pipeline
    And I should be able to track the health and status of the pipeline

  Scenario: Identifying performance bottlenecks
    Given I have a data synchronization pipeline with monitoring enabled
    When I analyze the metrics and logs
    Then I should be able to identify performance bottlenecks
    And I should be able to optimize the pipeline based on the insights
