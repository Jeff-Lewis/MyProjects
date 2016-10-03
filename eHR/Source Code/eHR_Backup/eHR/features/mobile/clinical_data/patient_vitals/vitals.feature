#Name             : Vitals
#Description      : covers scenarios under Vitals feature for mobile web
#Author           : Chandra sekaran

@all @mobile @vital @milestone10
Feature: Mobile - Verification of Clinical Data - Vitals

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_902
  Scenario: Verify that the user can Add vitals to a new patient
    Given a new patient is created "with Exam"
    When the "vitals" are "added" to the patient
    And a patient is selected at "random" with value "auto"
    Then the "vitals" data "should" be present in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "vitals" data "should" be updated in "Vitals MU Checklist" section

  @tc_903
  Scenario: Verify that the user can Update vitals added to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "vitals" are "updated" to the patient
    And a patient is selected at "random" with value "auto"
    Then the "vitals" data "should" be updated in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "vitals" data "should" be updated in "Health Status" section