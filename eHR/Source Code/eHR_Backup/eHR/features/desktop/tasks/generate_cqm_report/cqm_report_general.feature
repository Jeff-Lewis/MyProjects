#Name             : Generate CQM Report - General
#Description      : covers scenarios of Generate CQM Report - General under Tasks
#Author           : Gomathi

@all @tasks_cqm_report_general @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate CQM Report - General

  Background:
    Given login as "non ep"

  @tc_4976
  Scenario: Verification of CQM Reports can not generate for From Date greater than To Date
    And set EP as "stage1 ep"
    When "Category 1" report is "generated" for "From date greater than To date"
    Then "To Date can not be earlier than From Date" message should be displayed
    When "Category 3" report is "generated" for "From date greater than To date"
    Then "To Date can not be earlier than From Date" message should be displayed
    When "Category 3" report is "printed" for "From date greater than To date"
    Then "To Date can not be earlier than From Date" message should be displayed

  @tc_6101
  Scenario: Verify that user cannot generate CQM Reports without selecting EP
    And set EP as "stage1 ep"
    When "Category 1" report is "generated" for "without EP"
    Then "Please select Eligible Professional" message should be displayed
    When "Category 3" report is "generated" for "without EP"
    Then "Please select Eligible Professional" message should be displayed
    When "Category 3" report is "printed" for "without EP"
    Then "Please select Eligible Professional" message should be displayed

  @tc_6103 @chrome
  Scenario: Verification of Category 1 CQM report Cannot be generated for inactive EP
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    When "Category 1" report is "generated"
    And "stage1 ep" is "inactivated"
    Then Inactivated EP is not listed in "CQM report" EP list

  @tc_6116 @chrome
  Scenario: Verification of Category 3 CQM report Cannot be generated for inactive EP
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    When "Category 3" report is "generated"
    When "Category 3" report is "printed"
    And "stage1 ep" is "inactivated"
    Then Inactivated EP is not listed in "CQM report" EP list
    And set EP as "stage1 ep"


