#Name             : Smoking Status
#Description      : Covers scenarios under Smoking Status feature for stage1
#Author           : Gomathi

@all @s1_smoking_status @stage1 @milestone6
Feature: AMC - Verification of Numerator and Denominator changes - Smoking Status - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_3801 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 1 Smoking Status AMC measure
    Given get "requirement" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Smoking Status" under "core set" should be "equal" to "50"
    When get help text of "Smoking Status" under "core set" from tooltip
    Then help text for "Smoking Status" should be equal to the text
    """
    More than 50% of all unique patients 13 years old or older seen by the EP or admitted to the eligible hospital's or CAH's inpatient or emergency department (POS 21 or 23) have smoking status recorded as structured data.
    """

  @tc_527
  Scenario: Verification of Smoking Status stage 1 AMC measure
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU and age greater than 13"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

    Given a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

    Given a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

    Given a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

    Given a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"

  @tc_4768
  Scenario: Verification of Smoking Status Stage 1 AMC measure does not account patients seen outside reporting period
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Smoking Status" numerator report under "core set"

  @tc_4770
  Scenario: Verification of Smoking Status Stage 1 AMC measure does not account for non Face-to-Face patients
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Smoking Status" numerator report under "core set"

  @tc_4771
  Scenario: Verification of Smoking Status Stage 1 AMC measure does not account for Inpatients
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Smoking Status" numerator report under "core set"

  @tc_4772
  Scenario: Verification of Smoking Status Stage 1 AMC measure does not take into account patients with inactive visits
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 13"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "1"
    And "a record" should be in "Smoking Status" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Smoking Status" numerator report under "core set"

  @tc_4774
  Scenario: Verification of Smoking Status Stage 1 AMC measure does not accounts for patients less than 13 years of age
    Given get "all" details of "Smoking Status" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age 12"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "smoking status" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Smoking Status" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Smoking Status" numerator report under "core set"
