#Name             : Medication List
#Description      : Covers scenarios under Medication List feature for stage1
#Author           : Gomathi

@all @s1_medication_list @stage1 @milestone4
Feature: AMC - Verification of Numerator and Denominator changes - Medication List - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_3593
  Scenario: Verification of Help text and Requirement for Stage 1 Medication List AMC measure
    When get "requirement" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Medication List" under "core set" should be "equal" to "80"
    When get help text of "Medication List" under "core set" from tooltip
    Then help text for "Medication List" should be equal to the text
    """
    More than 80% of all unique patients seen by the EP or admitted to the eligible hospital's or CAH inpatient or emergency department (POS 21 or 23) have at least one entry (or an indication that the patient is not currently prescribed any medications) recorded as structured data.
    """

  @tc_3592
  Scenario: Verification of Medication List Stage 1 AMC measure does not take into account inactive medications
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"
    When the "medication list" is "inactivated"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "decreased" by "1 and 0"
    And "invalid record" should not be in "Medication List" numerator report under "core set"

  @tc_4751
  Scenario: Verification of Medication List Stage 1 AMC measure does not account patients seen outside reporting period
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication List" numerator report under "core set"

  @tc_4752
  Scenario: Verification of Medication List Stage 1 AMC measure does not account non Face-to-Face patients
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Medication List" numerator report under "core set"

  @tc_4753
  Scenario: Verification of Medication List Stage 1 AMC measure does not account for Inpatients
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Medication List" numerator report under "core set"

  @tc_4754
  Scenario: Verification of Medication List Stage 1 AMC measure does not account patients with inactive visits
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Medication List" numerator report under "core set"

  @tc_4755
  Scenario: Verification of Medication List Stage 1 AMC measure
    Then get "all" details of "Medication List" under "core set" for "stage1 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When get "all" details of "Medication List" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "2" "coded medication list" are created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    And a patient is created "with MU"
    And "2" exams are created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication List" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication List" numerator report under "core set"