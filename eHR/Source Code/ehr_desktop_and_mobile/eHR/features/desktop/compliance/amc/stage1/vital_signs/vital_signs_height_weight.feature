#Name             : Vital Signs - Height and Weight
#Description      : Covers scenarios under Vital Signs -  Height and Weight feature for stage1
#Author           : Gomathi

@all @s1_vital_signs_height_and_weight @stage1 @milestone7
Feature: AMC - Verification of Numerator and Denominator changes - Vital Signs - Height and Weight - Stage 1

  Background:
    Given login as "non EP"

  @tc_663
  Scenario: Verification of Vital Signs - Height and Weight stage 1 AMC measure
    Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height and weight" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4835
  Scenario: Verification of Vital Signs - Height and Weight does not account for patients outside reporting period
    Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

  @tc_4836
 Scenario: Verification of Vital Signs - Height and Weight does not account non face-to-face patients
    Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "height weight and BP" are added "within reporting period" under "health status"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
    And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

 @tc_4837
 Scenario: Verification of Vital Signs - Height and Weight does not account for Inpatients
   Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
   And a patient is created "with MU"
   When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
   And "height weight and BP" are added "within reporting period" under "health status"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
   And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
   When the exam is updated as "inpatient"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
   And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

 @tc_4838
 Scenario: Verification of Vital Signs - Height and Weight does not account for patients with inactive visits
   Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
   And a patient is created "with MU"
   When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
   And "height weight and BP" are added "within reporting period" under "health status"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "1"
   And "a record" should be in "Vital Signs - Height and Weight" numerator report under "core set"
   When the exam is updated as "inactive"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "decreased" by "1"
   And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

 @tc_4839
 Scenario: Verification of Vital signs-Height and weight Stage 1 does not account patients with no height or weight recorded
   Given get "all" details of "Vital Signs - Height and Weight" under "core set" for "stage1 ep" as "within report range"
   And a patient is created "with MU"
   When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
   And "height" is added "within reporting period" under "health status"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0 and 1"
   And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"

   Given a patient is created "with MU"
   When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
   And "height" is added "within reporting period" under "health status"
   Then the "numerator and denominator" of "Vital Signs - Height and Weight" under "core set" should be "increased" by "0 and 1"
   And "invalid record" should not be in "Vital Signs - Height and Weight" numerator report under "core set"
