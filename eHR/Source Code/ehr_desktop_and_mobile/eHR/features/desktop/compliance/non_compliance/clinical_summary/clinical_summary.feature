#Name             : Clinical Summary (EOE)
#Description      : Covers scenarios under Non Compliance related to Clinical Summary (EOE)
#Author           : Mani.Sundaram

@all @non_compliance @non_compliance_clinical_summary @chrome @milestone8
Feature: Non Compliance - Verification of Non Compliance Scenarios - Clinical Summary (EOE)

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_1128
  Scenario: To complete EOE via Non Compliance Report
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "20 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "clinical summary (eoe)" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When EOE is generated for the exam from "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

  @tc_7406
  Scenario: To complete EOE via Non Compliance - Multiple Visits on single day
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "2 hours" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 hour" "before" the reporting period
    When the Non Compliance report for "today" is generated for "clinical summary (eoe)" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    When EOE is generated for the exam from "non compliance report"
    Then "2" exams should "not be" "present" in "non compliance report"

  @tc_7411
  Scenario: To complete EOE via Non Compliance - Multiple Visits on different day
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 minute" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When the Non Compliance report for "all" is generated for "clinical summary (eoe)" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    When EOE is generated for the exam from "non compliance report"
    Then "1" exam should "be" "present" in "non compliance report"