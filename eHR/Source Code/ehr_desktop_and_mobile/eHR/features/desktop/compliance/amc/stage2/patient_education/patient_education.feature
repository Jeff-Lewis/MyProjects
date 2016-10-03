#Name             : Patient Education
#Description      : covers scenarios under Patient Education feature for stage2
#Author           : Chandra sekaran

@all @s2_patient_education @stage2 @milestone2
Feature: AMC - Verification of Numerator and Denominator changes - Patient Specific Education Resources - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_669 @tc_help_text
  Scenario: Verify Help text and Requirement column value for Patient Specific Education Resources stage2 AMC
    When get "requirement" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Patient Specific Education Resources" under "core set" should be "equal" to "10"
    When get help text of "Patient Specific Education Resources" under "core set" from tooltip
    Then help text for "Patient Specific Education Resources" should be equal to the text
    """
    Patient-specific education resources identified by Certified EHR Technology are provided to patients for more than 10 percent of all unique patients with office visits seen by the EP during the EHR reporting period.
    """

  @tc_6243 @chrome
  Scenario: Patient Education Material takes into account patients with office visits seen by the EP during reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    #And "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "core set"
    When a patient is created "with MU"
    And "2" exams are created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "core set"

  @tc_6244 @chrome
  Scenario: Patient Education Material does not take into account patients with non-office visits seen by the EP during reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active with CPT code" and "1 day" "before" the reporting period
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

  @tc_6245 @chrome
  Scenario: Patient Education Material does not take into account patients with office visits seen by the EP outside reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

  @tc_6246 @chrome
  Scenario: Patient Education Material does not take into account patients with office non face-to-face visits seen by the EP within reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "core set"
    When the exam is updated as "mu unchecked"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

  @tc_6247 @chrome
  Scenario: Patient Education Material does not take into account inpatient patients with office visits seen by the EP within reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

  @tc_6248 @chrome
  Scenario: Patient Education Material does not take into account patients with inactive office visits seen by the EP within reporting
            period and who were provided patient - specific education resource
    Then get "all" details of "Patient Specific Education Resources" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And EOE is generated and the patient specific education details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Specific Education Resources" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Patient Specific Education Resources" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Specific Education Resources" numerator report under "core set"