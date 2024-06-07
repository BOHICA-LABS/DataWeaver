Feature: Data Integration
  As a developer
  I want to easily integrate various data sources and sinks
  So that I can build data synchronization pipelines

  Scenario: Connecting to a data source
    Given I have DataWeaver installed
    And I have a supported data source
    When I configure a source connector
    Then DataWeaver should successfully connect to the data source

  Scenario: Connecting to a data sink
    Given I have DataWeaver installed
    And I have a supported data sink
    When I configure a sink connector
    Then DataWeaver should successfully connect to the data sink

  Scenario: Creating a data synchronization pipeline
    Given I have configured a source connector
    And I have configured a sink connector
    When I create a connector pipeline
    Then DataWeaver should create a pipeline connecting the source and sink