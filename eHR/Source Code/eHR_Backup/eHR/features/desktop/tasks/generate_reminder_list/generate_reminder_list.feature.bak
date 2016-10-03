#Name             : Generate Reminder list
#Description      : covers scenarios of Generate Reminder list under Tasks
#Author           : Gomathi

@all @tasks_generate_reminder_list @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate Reminder list

  Background:
    Given login as "non ep"

  @tc_42
  Scenario: Verification of patient reminder list generation based on patient Sex
    Given a patient list is generated for "Sex" "Male" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page

  @tc_48
  Scenario: Verification of multiple checkboxes selection of races
    Given a patient list is generated for "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander, White (Caucasian), Other Race" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page

  @tc_49
  Scenario: Verification of Only 1 checkbox of race is checked
    Given a patient list is generated for "Race" "American Indian or Alaska Native" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page

  @tc_50
  Scenario: Verification of “decline to state” checkbox is checked
    Given a patient list is generated for "Race" "Declined to state" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page

  @tc_6717
  Scenario: Verify that user can generate Patient Reminder List based on ICD 9 Problems


  @tc_6718
  Scenario: Verification of Generate Reminder List based on coded Problems
    Given set EP as "stage1 ep"
    And a patient is created "with MU"
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" "coded problem list" is created "within reporting period" under "health status"

    When a patient list is generated for "Problem" "268519009 - Diabetic - poor control (finding)" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Inactive" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Active" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page
    When a patient list is generated for "Problem from date" "start date of year", "Problem to date" "today" in "Generate Reminder list" page
    Then patient list should be displayed in "Generate Reminder list" page
