Feature: Scalability and Performance
  As a developer
  I want DataWeaver to scale and perform efficiently
  So that I can handle high volumes of data

  Scenario: Scaling data synchronization pipelines
    Given I have a data synchronization pipeline
    When the data volume increases
    Then DataWeaver should scale the pipeline by adding more worker instances
    And DataWeaver should distribute the workload across the instances

  Scenario: Optimizing data transformations
    Given I have a data synchronization pipeline with data transformations
    When I optimize the transformation logic
    Then DataWeaver should process the data more efficiently
    And DataWeaver should minimize the overhead of data transformations