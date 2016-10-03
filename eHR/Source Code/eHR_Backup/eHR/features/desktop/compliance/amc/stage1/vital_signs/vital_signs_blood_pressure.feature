#Name             : Vital Signs - Blood Pressure
#Description      : Covers scenarios under Vital Signs - Blood Pressure feature for stage1
#Author           : Gomathi

@all @s1_vital_signs_blood_pressure @stage1 @milestone7
Feature: AMC - Verification of Numerator and Denominator changes - Vital Signs - Blood Pressure - Stage 1

  Background:
    Given login as "non EP"

  @tc_665
  Scenario: Verification of Vital Signs - Blood Pressure stage 1 AMC measure
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    Given a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    Given a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    Given a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    Given a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4829
  Scenario: Verification of Vitals sign - Blood Pressure stage 1 does not account patients seen outside reporting period
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4830
  Scenario: Verification of Vitals sign - Blood Pressure stage 1 does not account for non face-to-face patients
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4831
  Scenario: Verification of Vitals sign - Blood Pressure stage 1 does not account for Inpatients
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4832
  Scenario: Verification of Vitals sign - Blood Pressure stage 1 does not account for patients within inactive visits
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4833
  Scenario: Verification of Vital Signs - Blood Pressure Stage 1 AMC measure does not account patients less than 3 years old
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU and age less than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4834
  Scenario: Verification of Vital Signs-Blood Pressure Stage 1 does not account patients greater than 3 yrs with no BP recorded
    Given get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

