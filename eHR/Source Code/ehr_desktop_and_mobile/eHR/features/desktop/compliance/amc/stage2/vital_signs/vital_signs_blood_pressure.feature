#Name             : Vital Signs - Blood Pressure
#Description      : Covers scenarios under Vital Signs - Blood Pressure feature for stage2
#Author           : Gomathi

@all @s2_vital_signs_blood_pressure @stage2 @milestone3
Feature: AMC - Verification of Numerator and Denominator changes - Vital Signs - Blood Pressure - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_6623 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 2 Vital Signs - Blood Pressure
    When get "requirement" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Vital Signs - Blood Pressure" under "core set" should be "equal" to "80"
    When get help text of "Vital Signs - Blood Pressure" under "core set" from tooltip
    Then help text for "Vital Signs - Blood Pressure" should be equal to the text
    """
    More than 80 percent of all unique patients seen by the EP have blood pressure (for patients age 3 and over only) and /or height and weight (for all ages) recorded as structured data.
    """

  @tc_235
  Scenario: Verification of Vital Signs - Blood Pressure stage 2 AMC measure
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    And a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When a patient is created "with MU and age 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4811
  Scenario: Verification of Vital Signs - Blood Pressure does not account for patients outside reporting period
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4812
  Scenario: Verification of Vital Signs - Blood Pressure does not account for non face-to-face patients
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4813
  Scenario: Verification of Vital Signs - Blood Pressure does not account for Inpatients
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4814
  Scenario: Verification of Vital Signs - Blood Pressure does not account patients having inactive visit
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4815
  Scenario: Verification of Vital Signs - Blood Pressure does not account patients less than 3 years old
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age less than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_4816
  Scenario: Verification of Vital Signs - Blood Pressure does not account patients greater than 3 years old with no BP recorded
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_6625
  Scenario: Verification of Vital Signs - Blood Pressure stage 2 AMC measure - Patient with multiple visits
    Then get "all" details of "Vital Signs - Blood Pressure" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When a patient is created "with MU and age greater than 3"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

    When a patient is created "with MU and age greater than 3"
    And "2" exams are created for the patient as "active" and "1 day" "before" the reporting period
    And "BP" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Blood Pressure" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Blood Pressure" numerator report under "core set"

  @tc_213
  Scenario: Verification of Height and weight and Blood Pressure are recorded as 2 separate measure for AMC stage 2 report
    Given AMC report is generated for "stage2 ep" as "within report range"
    Then verify "Vital Signs - Blood Pressure" objective is present under "core set"
    And verify "Vital Signs - Height and Weight" objective is present under "core set"