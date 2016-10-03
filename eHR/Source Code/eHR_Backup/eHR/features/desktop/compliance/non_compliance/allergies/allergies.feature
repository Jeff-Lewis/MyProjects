#Name             : Allergies
#Description      : Covers scenarios under Non Compliance related to Allergies
#Author           : Mani.Sundaram

@all @non_compliance @non_compliance_allergies @milestone8
Feature: Non Compliance - Verification of Non Compliance Scenarios - Allergies

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_1123
  Scenario: To add Allergies via Non Compliance Report - Positive scenario
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "gadolinium contrast material allergy" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "Iodine contrast material allergy" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "coded medication allergen" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "uncoded medication allergen" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "10 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "no known medication allergies" is added for a exam in "non compliance report"
    Then "1" exam should "not be" "present" in "non compliance report"

  @tc_7404
  Scenario: To add Allergy for visit via Non Compliance - Negative scenario
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "5 minutes" "before" the reporting period
    When the Non Compliance report for "today" is generated for "Allergies" "related Non Compliance"
    Then "1" exam should "be" "present" in "Non Compliance report"
    When "1" "other allergy" is added for a exam in "non compliance report"
    Then "1" exam should "be" "present" in "non compliance report"

  @tc_7410
  Scenario: To add Allergies via Non Compliance Report - Multiple visit for patient
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 minute" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When the Non Compliance report for "all" is generated for "Allergies" "related Non Compliance"
    Then "2" exams should "be" "present" in "Non Compliance report"
    When "1" "no known medication allergies" is added for a exam in "non compliance report"
    Then "2" exams should "not be" "present" in "non compliance report"