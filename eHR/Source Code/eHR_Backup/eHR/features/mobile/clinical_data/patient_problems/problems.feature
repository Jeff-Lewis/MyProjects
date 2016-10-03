#Name             : Problems
#Description      : covers scenarios under Problems feature for mobile web
#Author           : Chandra sekaran

@all @mobile @problem @milestone10
Feature: Mobile - Verification of Clinical Data - Problems

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_891
  Scenario: Verify that the user can add problems to an existing patient
    Given a patient is selected at "random" with value "auto"
    When a "problem" is "added" to the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "problem" data "should" be reflected in "Health Status" section

  @tc_892
  Scenario: Verify that the user can Update the already added problems of an existing patient
    Given a patient is selected at "random" with value "auto"
    When the "problem" is "inactivated" for the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When the "problem" is "activated" for the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section

  @tc_896
  Scenario: Verify that the user can Delete already added problems of an existing patient
    Given a patient is selected at "random" with value "auto"
    When the "problem" is "deleted" for the patient
    Then the "problem" data "should not" be reflected in "Clinical Data" section

  @tc_3392
  Scenario: Verify that the user can Add ,Edit and Delete problems to a new patient
    When a new patient is created "with Exam"
    And a "problem" is "added" to the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When the "problem" is "inactivated" for the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When the "problem" is "activated" for the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section
    When the "problem" is "deleted" for the patient
    Then the "problem" data "should not" be reflected in "Clinical Data" section
    And a "problem" is "added" to the patient
    Then the "problem" data "should" be reflected in "Clinical Data" section

  @tc_3576
  Scenario: Verify that the user can Add None Known for problems for a new patient
    When a new patient is created "with Exam"
    When the "problem" is set to "None Known" for the patient
    Then the "none known problem" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "problem" data "should" be reflected in "Problem MU Checklist" section