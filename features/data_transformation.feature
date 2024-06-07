Feature: Data Transformation
  As a developer
  I want to perform data transformations within connectors
  So that I can manipulate and enrich the data during synchronization

  Scenario: Transforming data in a source connector
    Given I have a source connector
    When I implement the process method
    And I apply data transformations to the incoming data
    Then DataWeaver should transform the data before producing it to the stream

  Scenario: Transforming data in a sink connector
    Given I have a sink connector
    When I implement the process method
    And I apply data transformations to the consumed data
    Then DataWeaver should transform the data before writing it to the sink
