#Name             : CPOE for Laboratory orders
#Description      : covers scenarios under CPOE for Laboratory orders feature for stage2
#Author           : Gomathi

@all @s2_cpoe_for_laboratory_orders @stage2 @milestone1
Feature: AMC - Verification of Numerator and Denominator changes - CPOE for laboratory Orders - Stage 2

  Background:
    Given login as "non ep"
    
  @tc_5804 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 2 CPOE for laboratory orders
    And get "requirement" details of "CPOE for Laboratory Orders" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "CPOE for Laboratory Orders" under "core set" should be "equal" to "30"
    When get help text of "CPOE for Laboratory Orders" under "core set" from tooltip
    Then help text for "CPOE for Laboratory Orders" should be equal to the text
    """
    More than 60 percent of medications, 30 percent of laboratory, and 30 percent of radiology orders are created by the EP during the EHR reporting period and recorded using CPOE.
    """

  @tc_707
  Scenario: Verification of Denominator for CPOE for laboratory orders Stage 2 AMC measure
    And get "all" details of "CPOE for Laboratory Orders" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "1"

    When a patient is created "with MU"
    And "2" "laboratory order" are placed "within reporting period" for the patient
    Then the "denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "2"

  @tc_708
  Scenario: Verification of Numerator for CPOE for laboratory orders Stage 2 AMC measure
    And get "all" details of "CPOE for Laboratory Orders" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "0 and 1"

    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Laboratory Orders" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Laboratory Orders" numerator report under "core set"

    When a patient is created "with MU"
    And "2" "laboratory order" are placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "2"
    And "a record" should be in "CPOE for Laboratory Orders" numerator report under "core set"

  @tc_223
  Scenario: Verification of CPOE for laboratory orders measure does not take into account cancelled laboratory orders
    And get "all" details of "CPOE for Laboratory Orders" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "2" "laboratory order" are placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "0 and 2"
    When the "laboratory order" is cancelled for the patient
    Then the "denominator" of "CPOE for Laboratory Orders" under "core set" should be "decreased" by "1"

    When login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Laboratory Orders" numerator report under "core set"
    When the "laboratory order" is cancelled for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "decreased" by "1"
    And "cancelled record" should not be in "CPOE for Laboratory Orders" numerator report under "core set"

  @tc_4846
  Scenario: Verification of CPOE for laboratory orders Stage 2 does not consider orders placed outside reporting period
    And get "all" details of "CPOE for Laboratory Orders" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "0"

    When a patient is created "with MU"
    And login as "stage2 ep"
    And the latest patient record is selected
    And "1" "laboratory order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Laboratory Orders" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "CPOE for Laboratory Orders" numerator report under "core set"