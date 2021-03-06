#Name             : Vital Signs - Height and Weight
#Description      : Covers scenarios under Vital Signs -  Height and Weight feature for stage2
#Author           : Gomathi

@all @s2_vital_signs_height_and_weight @stage2 @milestone3
Feature: AMC - Verification of Numerator and Denominator changes - Vital Signs - Height and Weight - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_38 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 2 Vital Signs - Height and Weight AMC measure
    When get "requirement" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Vital Signs - Height and Weight" under "core set" should be "equal" to "80"
    When get help text of "Vital Signs - Height and Weight" under "core set" from tooltip
    Then help text for "Vital Signs - Height and Weight" should be equal to the text
    """
    More than 80 percent of all unique patients seen by the EP have blood pressure (for patients age 3 and over only) and /or height and weight (for all ages) recorded as structured data.
    """

  @tc_233
  Scenario: Verification of Vital signs - Height and weight stage 2 AMC measure
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4817
  Scenario: Verification of Vital signs - Height and weight stage 2 measure does not account for patients seen outside reporting
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4818
  Scenario: Verification of Vital signs - Height and weight stage 2 measure does not account for non face-to-face patients
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4819
  Scenario: Verification of Vital signs - Height and weight stage 2 measure does not account for Inpatients
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4820
  Scenario: Verification of Vital signs - Height and weight stage 2 measure does not account for patients with inactive visits
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4821
  Scenario: Verification of Vital signs - Height and weight does not account for patients with no height or weight recorded
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "weight" is added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_6626
  Scenario: Verification of Vital signs - Height and weight stage 2 AMC measure - Patient with multiple visits
    Then get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    When a patient is created "with MU"
    And "2" exams are created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"