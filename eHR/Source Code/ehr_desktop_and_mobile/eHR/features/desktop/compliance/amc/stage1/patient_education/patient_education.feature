#Name             : Patient Specific Education Resources
#Description      : covers scenarios under Patient Specific Education Resources feature for stage1
#Author           : Gomathi

@all @s1_patient_specific_education_resources @stage1 @milestone5
Feature: AMC - Verification of Numerator and Denominator changes - Patient Specific Education Resources - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_3802 @tc_help_text
  Scenario: Verification of Help text and Requirement column for Stage 1 Patient Specific Education Resources AMC measure
    When get "requirement" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Patient Specific Education Resources" under "menu set" should be "equal" to "10"
    When get help text of "Patient Specific Education Resources" under "menu set" from tooltip
    Then help text for "Patient Specific Education Resources" should be equal to the text
    """
    More than 10% of all unique patients seen by the EP or admitted to the eligible hospital's or CAH's inpatient or emergency department (POS 21 and 23) during the EHR reporting period are provided patient-specific education resources.
    """

  @tc_673 @chrome
  Scenario: Verification of Patient Specific Education Resources stage 1 AMC measure
    Then get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active with CPT code" and "1 day" "before" the reporting period
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"

    When get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active with patient education modality" and "1 day" "before" the reporting period
    # Modality for which Patient Education Material is configured in the system is selected for the exam
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    # EOE generated outside reporting period
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"

  @tc_4849 @chrome
  Scenario: Verification of Patient Education Stage 1 does not take into account patients seen outside reporting period
    Then get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

  @tc_4909 @chrome
  Scenario: Verification of Patient Education Stage 1 AMC does not take into account non face-to-face patients
    Then get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"
    When the exam is updated as "mu unchecked"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

  @tc_4912 @chrome
  Scenario: Verification of Patient Education Stage 1 AMC measure does not take into account Inpatients
    Then get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient with patient education modality" and "1 day" "before" the reporting period
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active with patient education modality" and "1 day" "before" the reporting period
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

  @tc_6729 @chrome
  Scenario: Verification of Patient Education Stage 1 AMC measure does not take into account patients with inactive visits
    Then get "all" details of "Patient Specific Education Resources" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive with patient education modality" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active with patient education modality" and "1 day" "before" the reporting period
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "menu set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "menu set"