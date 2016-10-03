#Name             : General
#Description      : covers scenarios under General feature for mobile web
#Author           : Chandra sekaran

@all @mobile @general @milestone10
Feature: Mobile - Verification of Clinical Data - General

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_889
  Scenario: Verify that the details of an existing patient can be updated
    Given a patient is selected at "random" with value "auto"
    When "All" demographics data are updated
    Then the "all demographics" data "should" be updated in "Demographics" section

  @tc_1606
  Scenario: Verify that selected EP is considered as the default EP for new or existing patient
    Given relogin into mobile web application
    And a physician is selected "from config"
    And a new patient is created "with Exam"
    When a "problem" is "added" to the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When a patient is selected at "random" with value "auto"
    And an "valid" exam is added for the patient

  @tc_1608
  Scenario: Verify that the patient and exam can be created with no single-race or do not count for MU
    Given a new patient is created "with no Race"
    When an "unchecked Count for MU" exam is added for the patient
    And a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "no Race" data "should" be reflected in "Health Status" section
    And the "unchecked Count for MU" data "should" be reflected in "Select Patient" section

  @tc_1609
  Scenario: Verify that the exam can be created with out including visiting notes
#    When a patient is selected at "random" with value "auto"
    Given a new patient is created
    When an "unchecked Add visit notes to Clinical Summary" exam is added for the patient
    And a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "checked Exclude visit notes from summary" data "should" be reflected in "Select Patient" section

  @tc_3573
  Scenario: Verify that the MU Check is showing correctly when creating a new exam
    Given a "non EP" user is logged in "desktop" web application
    When the "Auto Face to Face Visit" is "unchecked" in Organization tab
    And a "non EP" user is logged in "mobile" web application
    And a patient is selected at "random" with value "auto"
    Then the "unchecked Count for MU" data "should" be present in "Exam Information" section

    Given a "non EP" user is logged in "desktop" web application
    When the "Auto Face to Face Visit" is "checked" in Organization tab
    And a "non EP" user is logged in "mobile" web application
    And a patient is selected at "random" with value "auto"
    Then the "checked Count for MU" data "should" be present in "Exam Information" section

  @tc_3574
  Scenario: Verify that the Organization settings for CPT is showing correctly when creating a new exam
    Given a "non EP" user is logged in "desktop" web application
    When the "default CPT Code" is "set" in Organization tab
    And a "non EP" user is logged in "mobile" web application
    And a patient is selected at "random" with value "auto"
    Then the "default CPT Code" data "should" be present in "Exam Information" section

    Given a "non EP" user is logged in "desktop" web application
    When the "default CPT Code" is "cleared" in Organization tab
    And a "non EP" user is logged in "mobile" web application
    And a patient is selected at "random" with value "auto"
    Then the "default CPT Code" data "should not" be present in "Exam Information" section

  @tc_7322
  Scenario: Verify that the "Ethnicity" is spelled correctly in patient Demographics section
    Given a patient is selected at "random" with value "auto"
    Then the "Ethnicity" text "should" be present in "Demographics" section