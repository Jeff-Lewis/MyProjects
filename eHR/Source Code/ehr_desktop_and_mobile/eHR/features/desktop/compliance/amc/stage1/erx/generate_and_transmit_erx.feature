#Name             : Generate and Transmit eRX
#Description      : covers scenarios under Generate and Transmit eRX feature for stage1
#Author           : Gomathi

@all @s1_generate_and_transmit_eRx @stage1 @milestone5
Feature: AMC - Verification of Numerator and Denominator changes - Generate and Transmit eRx - Stage 1

  Background:
    Given login as "stage1 ep"
    
  @tc_3555 @tc_help_text
  Scenario: Verification of Help text and Requirement for 'Generate and Transmit eRx' Stage 1 AMC measure
    And get "requirement" details of "Generate and Transmit eRx" under "core set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Generate and Transmit eRx" under "core set" should be "equal" to "40"
    When get help text of "Generate and Transmit eRx" under "core set" from tooltip
    Then help text for "Generate and Transmit eRx" should be equal to the text
    """
    More than 40% of all permissible prescriptions written by the EP are transmitted electronically using certified EHR technology.
    """

  @tc_535
  Scenario: Verification of Denominator value for Generate and transmit eRX stage 1 AMC measure
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 1"

    When a patient is created "with MU"
    And "2" "hand written medication order" are placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 2"

    When a patient is created "with MU"
    And "1" "hand written medication order from master list" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0 and 1"

  @tc_536
  Scenario: Verification of Numerator value for Generate and transmit eRx stage 1 AMC measure
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage1 ep" as "within report range"
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
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "1"
    And "a record" should be in "Generate and Transmit eRx" numerator report under "core set"

  @tc_6723
  Scenario: Verification of Stage 1 eRX does not take into account orders placed outside reporting period
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage1 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "outside reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "e-prescribed medication order" is placed "outside reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"

  @tc_6724
  Scenario: Verification of Stage 1 eRx does not take into account orders for controlled substances
    Then get "all" details of "Generate and Transmit eRx" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "medication order with controlled substance" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "Generate and Transmit eRx" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Generate and Transmit eRx" numerator report under "core set"