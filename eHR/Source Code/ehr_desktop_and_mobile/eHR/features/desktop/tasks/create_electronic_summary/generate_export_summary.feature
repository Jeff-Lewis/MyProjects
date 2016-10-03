#Name             : Generate Export Summary
#Description      : covers scenarios of Generate Export Summary under Tasks
#Author           : Gomathi

@all @tasks_generate_export_summary @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate Export Summary

  @tc_961
  Scenario: Verification of Generate Export Summary for an specified time period
    Given login as "non ep"
    When currently in "Generate Export Summary" page
    Then export summary is generated