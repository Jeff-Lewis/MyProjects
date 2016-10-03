#Name             : Problems
#Description      : Covers scenarios under Non Compliance related to Problems
#Author           : Mani.Sundaram

@all @non_compliance @non_compliance_problems @milestone8
Feature: Non Compliance - Verification of Non Compliance Scenarios - Problems

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_1112
  Scenario: To Add Problem via Non Compliance Report - Positive scenario
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Problems" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "coded problem list" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "25 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Problems" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "none known problem list" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

  @tc_7413
  Scenario: To Add Problem via Non Compliance Report - Negative Scenario
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Problems" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    And "1" "uncoded problem list" is added for a exam in "non compliance report"
    Then "1" exam should "be" "present" in "non compliance report"

  @tc_7414
  Scenario: To Add Problem via Non Compliance Report - Multiple visits for patient
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 minute" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When the Non Compliance report for "all" is generated for "Problems" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    And "1" "none known problem list" is added for a exam in "non compliance report"
    Then "2" exams should "not be" "present" in "non compliance report"