#Name             : Smoking Status
#Description      : covers scenarios under Smoking Status feature for mobile web
#Author           : Chandra sekaran

@all @mobile @smoking_status @milestone10
Feature: Mobile - Verification of Clinical Data - Smoking Status

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_900
  Scenario: Verify that the user can Add smoking status to a patient record
    Given a patient is selected at "random" with value "auto"
    When a "smoking status" is "added" to the patient
    Then the "smoking status" data "should" be reflected in "Clinical Data" section

  @tc_901
  Scenario: Verify that the user can Update smoking status added to a patient record
    Given a patient is selected at "random" with value "auto"
    When a "smoking status" is "updated" to the patient
    Then the "smoking status" data "should" be reflected in "Clinical Data" section