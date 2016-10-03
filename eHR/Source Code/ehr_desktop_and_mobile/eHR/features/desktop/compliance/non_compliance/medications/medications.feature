#Name             : Medications
#Description      : Covers scenarios under Non Compliance related to Medications
#Author           : Mani.Sundaram

@all @non_compliance @non_compliance_medications @milestone8
Feature: Non Compliance - Verification of Non Compliance Scenarios - Medications

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_1124
  Scenario: To Add Medication via Non Compliance Report
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "5 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Medications" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "coded medication list" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "20 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Medications" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "uncoded medication list" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "25 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Medications" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "none known medication list" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

  @tc_7412
  Scenario: To Add Medication via Non Compliance Report - Patient having multiple visits
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 minute" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When the Non Compliance report for "all" is generated for "Medications" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    And "1" "none known medication list" is added for a exam in "non compliance report"
    Then "2" exams should "not be" "present" in "non compliance report"