#Name             : Incorporate Clinical Lab Results
#Description      : Covers scenarios under Incorporate Clinical Lab Results feature for stage2
#Author           : Gomathi

@all @s2_incorporate_clinical_lab_results @stage2 @milestone2
Feature: AMC - Verification of Numerator and Denominator changes - Incorporate Clinical Lab Results - Manual part - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_6242 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 2 Incorporate Clinical Lab Results AMC measure
    When get "requirement" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Incorporate Clinical Lab Results" under "core set" should be "equal" to "55"
    When get help text of "Incorporate Clinical Lab Results" under "core set" from tooltip
    Then help text for "Incorporate Clinical Lab Results" should be equal to the text
    """
    More than 55 percent of all clinical lab test results ordered by the EP during the EHR reporting period whose results are either in a positive/negative or numerical format are incorporated in certified EHR technology as structured data.
    """

  @tc_6227
  Scenario: Verification of Stage 2 Incorporated Clinical Lab Results takes into account manually entered numeric results
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "numeric affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6228
  Scenario: Verification of Stage 2 Lab Results takes into account manually entered positive lab results
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "positive affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "positive affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "positive affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6229
  Scenario: Verification of Stage 2 Lab Results takes into account manually entered negative lab results
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6230
  Scenario: Verification of Stage 2 Lab Results does not take into account results which are not positive, negative or numeric
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "not numeric affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0 and 1"
    When a lab result is added as "not positive affirmation" and report date is "within reporting period" for the patient
    Then the "denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0 and 1"
    When a lab result is added as "not negative affirmation" and report date is "outside reporting period" for the patient
    Then the "denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6231
  Scenario: Verification of Stage 2 Lab Results does not take into account manual results added outside reporting period
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "positive affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" "laboratory order" is placed "outside reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "outside reporting period" for the patient
    And a lab result is added as "numeric affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6232
  Scenario: Verification of Stage 2 Lab Results does not take into account orders with cancelled status
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0 and 1"
    When the "laboratory order" is cancelled for the patient
    Then the "denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "positive affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When the "laboratory order" is cancelled for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6233
  Scenario: Verification of Stage 2 Lab Results does not take into account lab results with inactive status
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "positive affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When the lab result is "inactivated" for the patient
    Then the "numerator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When the lab result is "inactivated" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1 and 0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6234
  Scenario: Verification of Stage 2 Lab Results does not take into account lab results deleted from system
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When the lab result is "deleted" for the patient
    Then the "numerator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When the lab result is "deleted" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1 and 0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6235
  Scenario: Verification of Stage 2 Lab Results for multiple manually entered lab orders and lab results within reporting period
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    And a lab result is added as "positive affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1 and 0"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "negative affirmation" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "positive affirmation" and report date is "outside reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "1"
    And "a record" should be in "Incorporate Clinical Lab Results" numerator report under "core set"

  @tc_6549
  Scenario: Verification of Stage 2 Lab results does not take into account uncoded (save as typed) lab results
    And get "all" details of "Incorporate Clinical Lab Results" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And a lab result is added as "uncoded" and report date is "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0 and 1"
    And a lab result is added as "uncoded" and report date is "within reporting period" for the patient
    Then the "denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"

    When a patient is created "with MU"
    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Incorporate Clinical Lab Results" under "core set" should be "increased" by "0 and 1"
    And a lab result is added as "uncoded" and report date is "outside reporting period" for the patient
    Then the "denominator" of "Incorporate Clinical Lab Results" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Incorporate Clinical Lab Results" numerator report under "core set"


