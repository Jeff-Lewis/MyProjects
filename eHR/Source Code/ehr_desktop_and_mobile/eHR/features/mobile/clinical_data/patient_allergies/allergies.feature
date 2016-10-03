#Name             : Allergies
#Description      : covers scenarios under Allergies feature for mobile web
#Author           : Chandra sekaran

@all @mobile @allergies @milestone10
Feature: Mobile - Verification of Clinical Data - Allergies

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_897
  Scenario: Verify that the user can add Med Allergies to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When a "med allergy" is "added" to the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "med allergy" data "should" be reflected in "Health Status" section

  @tc_898
  Scenario: Verify that the user can update Med Allergies added to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When a "med allergy" is "added" to the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section
    When the "med allergy" is "inactivated" for the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section
    When the "med allergy" is "activated" for the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section

  @tc_899
  Scenario: Verify that the user can delete Med Allergies added to an existing patient
    Given a patient is selected at "random" with value "auto"
    When a "med allergy" is "added" to the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section
    When the "med allergy" is "deleted" for the patient
    Then the "med allergy" data "should not" be reflected in "Clinical Data" section

  @tc_3557
  Scenario: Verify that the user can add Med Allergies to a new patient
    Given a new patient is created "with Exam"
    When a "med allergy" is "added" to the patient
    Then the "med allergy" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "med allergy" data "should" be reflected in "Allergies MU Checklist" section

  @tc_3558
  Scenario: Verify that the user can Add None Known for allergies for a new patient
    Given a new patient is created "with Exam"
    When the "med allergy" is set to "None Known" for the patient
    Then the "none known med allergy" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "med allergy" data "should" be reflected in "Allergies MU Checklist" section