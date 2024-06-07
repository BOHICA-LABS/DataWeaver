Feature: Connector Framework
  As a developer
  I want to create custom connectors
  So that I can integrate with specific data sources and sinks

  Scenario: Creating a custom source connector
    Given I have DataWeaver installed
    When I extend the SourceConnector base class
    And I implement the required methods
    Then I should be able to create a custom source connector

  Scenario: Creating a custom sink connector
    Given I have DataWeaver installed
    When I extend the SinkConnector base class
    And I implement the required methods
    Then I should be able to create a custom sink connector