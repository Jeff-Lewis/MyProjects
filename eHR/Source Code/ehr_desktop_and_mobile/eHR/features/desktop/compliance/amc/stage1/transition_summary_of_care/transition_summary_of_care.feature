#Name             : Transition Summary of Care
#Description      : Covers scenarios under Transition Summary of Care feature for stage1
#Author           : Gomathi

@all @s1_transition_summary_of_care @stage1 @milestone6
Feature: AMC - Verification of Numerator and Denominator changes - Transition Summary of Care - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_4230 @tc_help_text
  Scenario: Verification of Help text and Requirement column for Transition Summary of Care Stage 1 AMC measure
    Given get "requirement" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Transition Summary of Care" under "menu set" should be "equal" to "50"
    When get help text of "Transition Summary of Care" under "menu set" from tooltip
    Then help text for "Transition Summary of Care" should be equal to the text
    """
    The EP, eligible hospital or CAH who transitions or refers their patient to another setting of care or provider of care provides a summary of care record for more than 50% of transitions of care and referrals.
    """

  @tc_4229 @chrome
  Scenario: Verification of Transition Summary of Care stage 1 AMC measure
    Given get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"
    When get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"

  @tc_4775 @chrome
  Scenario: Verification of Transition Summary of Care does not account for patients having referrals outside reporting period
    Given get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

  @tc_4776 @chrome
  Scenario: Verification of Transition Summary of Care does not account for non Face-to-Face patients with referrals
    Given get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

  @tc_4777 @chrome
  Scenario: Verification of Transition Summary of Care does not account for Inpatients with referrals
    Given get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

  @tc_4778 @chrome
  Scenario: Verification of Transition Summary of Care does not account for inactive visits
    Given get "all" details of "Transition Summary of Care" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

    Given a patient is created "with MU"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "increased" by "1"
    And "a record" should be in "Transition Summary of Care" numerator report under "menu set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Transition Summary of Care" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "Transition Summary of Care" numerator report under "menu set"

