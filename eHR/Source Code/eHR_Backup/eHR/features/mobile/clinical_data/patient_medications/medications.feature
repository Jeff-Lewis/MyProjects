#Name             : Medications
#Description      : covers scenarios under Medications feature for mobile web
#Author           : Chandra sekaran

@all @mobile @medication @milestone10
Feature: Mobile - Verification of Clinical Data - Medications

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_893
  Scenario: Verify that the user can add Medications to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When a "medication" is "added" to the patient
    Then the "medication" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "medication" data "should" be reflected in "Health Status" section

  @tc_894
  Scenario: Verify that the user can Activate or Inactivate Medications added to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "medication" is "inactivated" for the patient
    Then the "medication" data "should" be reflected in "Clinical Data" section
    When the "medication" is "activated" for the patient
    Then the "medication" data "should" be reflected in "Clinical Data" section

  @tc_895
  Scenario: Verify that the user can Delete Medications added to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "medication" is "deleted" for the patient
    Then the "medication" data "should not" be reflected in "Clinical Data" section

  @tc_3560
  Scenario: Verify that the user can Add Medication to a new patient
    When a new patient is created "with Exam"
    When a "medication" is "added" to the patient
    Then the "medication" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "medication" data "should" be reflected in "Medication MU Checklist" section

  @tc_3561
  Scenario: Verify that the user can Add None Known for Medication for a new patient
    When a new patient is created "with Exam"
    When the "medication" is set to "None Known" for the patient
    Then the "none known medication" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "medication" data "should" be reflected in "Medication MU Checklist" section