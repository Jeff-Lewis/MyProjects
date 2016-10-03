#Name             : Family History
#Description      : covers scenarios under Family history feature for mobile web
#Author           : Chandra sekaran

@all @mobile @family_history @milestone10
Feature: Mobile - Verification of Clinical Data - Family History

  Background:
    Given a "non EP" user is logged in "mobile" web application
    And a physician is selected "from config"

  @tc_3588
  Scenario: Verify that the user can add None Known for Family history for a new patient
    Given a new patient is created "with Exam"
    When a "family history" is set to "none known" to the patient
    Then the "none known family history" data "should" be reflected in "Clinical Data" section

  @tc_1603
  Scenario: Verify that the user can add Family history to an existing patient record
    Given a patient is selected at "random" with value "auto"
    When a "coded family history" is "added" to the patient
    Then the "coded family history" data "should" be reflected in "Clinical Data" section
    When an "uncoded family history" is "added" to the patient
    Then the "uncoded family history" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "family history" data "should" be reflected in "Health Status" section

  @tc_1604
  Scenario: Verify that the user can Inactivate Family history of an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "coded family history" is "inactivated" for the patient
    Then the "coded family history" data "should" be reflected in "Clinical Data" section
    When the "uncoded family history" is "inactivated" for the patient
    Then the "uncoded family history" data "should" be reflected in "Clinical Data" section

  @tc_2390
  Scenario: Verify that the user can Activate Family history of an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "coded family history" is "activated" for the patient
    Then the "coded family history" data "should" be reflected in "Clinical Data" section
    When the "uncoded family history" is "activated" for the patient
    Then the "uncoded family history" data "should" be reflected in "Clinical Data" section

  @tc_1605
  Scenario: Verify that the user can Delete Family history of an existing patient record
    Given a patient is selected at "random" with value "auto"
    When the "coded family history" is "deleted" for the patient
    Then the "coded family history" data "should not" be present in "Clinical Data" section
    When the "uncoded family history" is "deleted" for the patient
    Then the "uncoded family history" data "should not" be present in "Clinical Data" section

  @tc_2380
  Scenario: Verify that the user can add an Uncoded Family History related to every relationship manually for an existing patient
    Given a patient is selected at "random" with value "auto"
    When an "uncoded family history for Father" is "added" to the patient
    When an "uncoded family history for Mother" is "added" to the patient
    When an "uncoded family history for Natural Son" is "added" to the patient
    When an "uncoded family history for Natural Daughter" is "added" to the patient
    When an "uncoded family history for Brother" is "added" to the patient
    When an "uncoded family history for Sister" is "added" to the patient

  @tc_2378
  Scenario: Verify that the user can add an Uncoded Family History related to every relationship manually for a new patient
    Given a new patient is created "with Exam"
    When an "uncoded family history for Father" is "added" to the patient
    When an "uncoded family history for Mother" is "added" to the patient
    When an "uncoded family history for Natural Son" is "added" to the patient
    When an "uncoded family history for Natural Daughter" is "added" to the patient
    When an "uncoded family history for Brother" is "added" to the patient
    When an "uncoded family history for Sister" is "added" to the patient

  @tc_2387
  Scenario: Verify that the user cannot add the same Coded/Uncoded Family History (related to same Relationship) more than once
    Given a new patient is created "with Exam"
    When a "coded family history for Father" is "added" to the patient
    Then the "coded family history for Father" data "should" be present in "Clinical Data" section
    When the same "coded family history for Father" is "added" to the patient
    Then the "duplicate coded family history for Father" data "should not" be present in "Clinical Data" section

    When a "coded family history for Mother" is "added" to the patient
    Then the "coded family history for Mother" data "should" be present in "Clinical Data" section
    When the same "coded family history for Mother" is "added" to the patient
    Then the "duplicate coded family history for Mother" data "should not" be present in "Clinical Data" section

    When a "uncoded family history for Father" is "added" to the patient
    Then the "uncoded family history for Father" data "should" be present in "Clinical Data" section
    When the same "uncoded family history for Father" is "added" to the patient
    Then the "duplicate uncoded family history for Father" data "should not" be present in "Clinical Data" section

    When a "uncoded family history for Mother" is "added" to the patient
    Then the "uncoded family history for Mother" data "should" be present in "Clinical Data" section
    When the same "uncoded family history for Mother" is "added" to the patient
    Then the "duplicate uncoded family history for Mother" data "should not" be present in "Clinical Data" section

  @tc_3586
  Scenario: Verify that the user can add Family History to a new patient
    Given a new patient is created "with Exam"
    When a "coded family history" is "added" to the patient
    Then the "coded family history" data "should" be reflected in "Clinical Data" section
    When an "uncoded family history" is "added" to the patient
    Then the "uncoded family history" data "should" be reflected in "Clinical Data" section
    When a "non EP" user is logged in "desktop" web application
    And the latest patient record is selected
    Then the "family history" data "should" be reflected in "Health Status" section