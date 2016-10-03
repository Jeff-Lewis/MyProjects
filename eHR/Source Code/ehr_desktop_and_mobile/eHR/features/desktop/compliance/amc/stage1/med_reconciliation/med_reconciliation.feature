#Name             : Medication Reconciliation
#Description      : Covers scenarios under Medication Reconciliation feature for stage1
#Author           : Gomathi

@all @s1_medication_reconciliation @stage1 @milestone5
Feature: AMC - Verification of Numerator and Denominator changes - Medication Reconciliation - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_5510 @tc_help_text
  Scenario: Verification of Help text and Requirement value for Stage 1 Medication Reconciliation
    When get "requirement" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Medication Reconciliation" under "menu set" should be "equal" to "50"
    When get help text of "Medication Reconciliation" under "menu set" from tooltip
    Then help text for "Medication Reconciliation" should be equal to the text
    """
    The EP, eligible hospital or CAH performs medication reconciliation for more than 50% of transitions of care in which the patient is transitioned into care of the EP or admitted to the eligible hospital's or CAH's inpatient or emergency department (POS 21 or 23).
    """

  @tc_5003 @chrome
  Scenario: Verification of Stage 1 Med Reconciliation does not consider visits outside reporting period
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5005 @chrome
  Scenario: Verification of Stage 1 Medication Reconciliation does not take into account non Face to Face visits
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"
    When the exam is updated as "MU checked"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5006 @chrome
  Scenario: Verification of Stage 1 Medication Reconciliation does not take into account for Inpatients
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"
    When the exam is updated as "outpatient"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5007 @chrome
  Scenario: Verification of Stage 1 Medication Reconciliation does not take into account Inactive visits within reporting period
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "no change" button is clicked under "medication list"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"
    When the exam is updated as "active"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5011 @chrome
  Scenario: Verification of Stage 1 Med Reconciliation where reconciliation by adding medication on Health Status
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5012 @chrome
  Scenario: Verification of Stage 1 Med Reconciliation where reconciliation by clicking on None Known within RP
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_5509 @chrome
  Scenario: Verification of Stage 1 Med Reconciliation where reconciling medication from TOC
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "within reporting period"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    # Numerator count increased by 1
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "2"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconcile all" button is clicked for "medication" "outside reporting period"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_6559
  Scenario: Verification of Stage 1 Medication Reconciliation delete scenario - 1
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_6560
  Scenario: Verification of Stage 1 Medication Reconciliation delete scenario - 2
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "decreased" by "0"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_6561 @chrome
  Scenario: Verification of Stage 1 Medication Reconciliation delete scenario - 3
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconciliation" is clicked from MU checklist ribbon for "medication"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"

  @tc_6562 @chrome
  Scenario: Verification of Stage 1 Medication Reconciliation delete scenario - 4
    Then get "all" details of "Medication Reconciliation" under "menu set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"
    When the "medication list" is "deleted"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And TOC is uploaded and attached with "medication" for the recent exam
    And "reconciliation" is clicked from MU checklist ribbon for "medication"
    Then the "numerator and denominator" of "Medication Reconciliation" under "menu set" should be "increased" by "1"
    And "a record" should be in "Medication Reconciliation" numerator report under "menu set"