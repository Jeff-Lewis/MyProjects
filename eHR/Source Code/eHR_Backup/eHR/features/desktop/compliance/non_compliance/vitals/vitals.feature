#Name             : Vitals
#Description      : Covers scenarios under Non Compliance related to Vitals
#Author           : Mani.Sundaram

@all @non_compliance @non_compliance_vitals @milestone8
Feature: Non Compliance - Verification of Non Compliance Scenarios - Vitals

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_7416
  Scenario: To Add All Vitals via Non Compliance Report
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Vitals" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "height" is added for a exam in "non compliance report"
    Then "1" exam should "be" "present" in "non compliance report"

    When "weight" is added for a exam in "non compliance report"
    Then "1" exam should "be" "present" in "non compliance report"

    When "BP" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

  @tc_7417
  Scenario: To Add Vitals via Non Compliance Report - Patient having multiple visits
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 minute" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When the Non Compliance report for "all" is generated for "Vitals" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    And "height weight and BP" are added for a exam in "non compliance report"
    Then "2" exams should "not be" "present" in "non compliance report"