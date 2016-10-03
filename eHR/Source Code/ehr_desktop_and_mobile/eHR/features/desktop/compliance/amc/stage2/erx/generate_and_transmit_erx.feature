#Name             : Generate and Transmit ERX
#Description      : covers scenarios under Generate and Transmit ERX feature for stage2
#Author           : Gomathi

@all @s2_generate_and_transmit_eRx @stage2 @milestone1
Feature: AMC - Verification of Numerator and Denominator changes - Generate and Transmit eRx - Stage 2

  Background:
    Given login as "stage2 ep"
    
  @tc_25 @tc_help_text
  Scenario: Verification of Help text and Requirement for Generate and Transmit eRx AMC measure
    And get "requirement" details of "Generate and Transmit eRx" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Generate and Transmit eRx" under "core set" should be "equal" to "50"
    When get help text of "Generate and Transmit eRx" under "core set" from tooltip
    Then help text for "Generate and Transmit eRx" should be equal to the text
    """
    More than 50 percent of all permissible prescriptions, or all prescriptions, written by the EP are queried for a drug formulary and transmitted electronically using CEHRT.
    """

  @tc_709
  Scenario: Verification of Denominator for Generate and transmit eRx stage 2 AMC measure
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 1"

    When a patient is created "with MU"
    And "2" "hand written medication order" are placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 2"

    When a patient is created "with MU"
    And "1" "hand written medication order from master list" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 1"

  @tc_5811
  Scenario: Verification of Generate and transmit eRx does not take into account orders created outside reporting period
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "outside reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "e-prescribed medication order" is placed "outside reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"

  @tc_710
  Scenario: Verification of Numerator for Generate and transmit eRx stage 2 AMC measure
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "e-prescribed medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "1"
    And "a record" should be in "Generate and Transmit eRx" numerator report under "core set"

    When a patient is created "with MU"
    And "2" "e-prescribed medication order" are placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "2"
    And "a record" should be in "Generate and Transmit eRx" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "e-prescribed medication order from master list" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"

  @tc_5812
  Scenario: Verification of Stage 2 Generate and transmit eRx objective does not take into account orders for controlled substances
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "medication order with controlled substance" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"