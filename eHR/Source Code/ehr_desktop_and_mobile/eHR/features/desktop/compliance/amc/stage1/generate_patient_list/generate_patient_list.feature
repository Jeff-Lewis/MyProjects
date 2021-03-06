#Name             : Generate Patient List
#Description      : Covers scenarios under Generate Patient List feature for stage1
#Author           : Gomathi

@all @s1_generate_patient_list @stage1 @milestone4
Feature: AMC - Verification of Percentage changes - Generate Patient List - Stage 1

  Background:
    Given login as "non ep"
    
  @tc_595 @tc_help_text
  Scenario: Verification of Help text for Generate Patient List stage 1 AMC measure
    When get "all" details of "Generate Patient List" under "menu set" for "stage1 ep" as "within report range"
    And get help text of "Generate Patient List" under "menu set" from tooltip
    Then help text for "Generate Patient List" should be equal to the text
    """
    Generate at least one report listing patients of the EP with a specific condition
    """

  @tc_596
  Scenario: Verification of Generate Patient List stage 1 AMC measure
    When get "all" details of "Generate Patient List" under "menu set" for "stage1 ep" as "within report range"
    And a "stage1 ep" is created with "current year" as "stage1 start year"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And get "percentage" details of "Generate Patient List" under "menu set" for "stage1 ep" as "within report range"
    Then the "percentage" of "Generate Patient List" under "menu set" should be "Not Performed"
    When a patient list is generated for "Exam date from" "Yesterday", "Exam date to" "Today" in "Generate Patient list" page
    And get "percentage" details of "Generate Patient List" under "menu set" for "stage1 ep" as "within report range"
    Then the "percentage" of "Generate Patient List" under "menu set" should be "Performed"
    When get "percentage" details of "Generate Patient List" under "menu set" for "stage1 ep" as "outside report range"
    Then the "percentage" of "Generate Patient List" under "menu set" should be "Not Performed"
    Then set "stage1 ep" as current EP