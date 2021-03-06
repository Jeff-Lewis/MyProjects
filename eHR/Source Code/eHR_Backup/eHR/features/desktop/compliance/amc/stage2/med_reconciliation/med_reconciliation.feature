#Name             : Medication Reconciliation
#Description      : Covers scenarios under Medication Reconciliation feature for stage2
#Author           : Gomathi

@all @s2_medication_reconciliation @stage2 @milestone2
Feature: AMC - Verification of Numerator and Denominator changes - Medication Reconciliation - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_717 @tc_help_text
  Scenario: Verification of Help text and threshold value for Medication reconciliation Stage 2 AMC measure
    When get "requirement" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Medication Reconciliation" under "core set" should be "equal" to "50"
    When get help text of "Medication Reconciliation" under "core set" from tooltip
    Then help text for "Medication Reconciliation" should be equal to the text
    """
    The EP who performs medication reconciliation for more than 50 percent of transitions of care in which the patient is transitioned into the care of the EP.
    """

  @tc_3398 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation does not take into account patients seen by EP outside reporting period
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

  @tc_5511 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation does not take into account non Face to Face patients
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"
    When the exam is updated as "MU checked"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

  @tc_5512 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation does not take into account Inpatients seen by EP during reporting period
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"
    When the exam is updated as "outpatient"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

  @tc_5513 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation does not take into account patients with inactive visit during reporting period
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"
    When the exam is updated as "active"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

  @tc_5514 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation with first time visit and reconciliation by adding medication
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1 and 2"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_5515 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation with first time visit and reconciliation clicking None Known
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_5516 @chrome
  Scenario: Verification of Stage 2 Med Reconciliation with not first time visit with EP and TOC
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 year" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "outside reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "1 year" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 year" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 year" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 year" "before" the reporting period
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1 and 2"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_6563 @chrome
  Scenario: Verification of Stage 2 Medication Reconciliation delete scenario - 1
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_6564
  Scenario: Verification of Stage 2 Medication Reconciliation delete scenario - 2
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_6565 @chrome
  Scenario: Verification of Stage 2 Medication Reconciliation delete scenario - 3
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"

  @tc_6566 @chrome
  Scenario: Verification of Stage 2 Medication Reconciliation delete scenarios - 4
    Then get "all" details of "Medication Reconciliation" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "core set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "core set"