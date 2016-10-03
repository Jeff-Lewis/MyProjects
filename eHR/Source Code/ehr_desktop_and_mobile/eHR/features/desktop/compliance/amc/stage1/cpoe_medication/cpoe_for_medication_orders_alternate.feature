#Name             : CPOE for Medication orders - Alternate
#Description      : covers scenarios under CPOE for Medication orders - Alternate feature for stage1
#Author           : Gomathi

@all @s1_cpoe_for_medication_orders_alternate @stage1 @milestone4
Feature: AMC - Verification of Numerator and Denominator changes - CPOE for Medication Orders - Alternate - Stage 1

  Background:
    Given login as "non ep"
    
  @tc_702
  Scenario: Verification of CPOE for medication orders - Alternate Stage 1 AMC measure
    And get "all" details of "CPOE for Medication Orders - Alternate" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "uncoded medication list" is created "within reporting period" under "health status"
    And login as "stage1 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1 and 2"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

    When login as "non ep"
    And a patient is created "with MU"
    And "2" "coded medication list" are created "within reporting period" under "health status"
    And login as "stage1 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1 and 3"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    And "1" "e-prescribed medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "2"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

  @tc_4845
  Scenario: Verification of CPOE for Med orders - Alternate Stage 1 does not take into account orders created outside RP
    And get "all" details of "CPOE for Medication Orders - Alternate" under "core set" for "stage1 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "0"
    And login as "stage1 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "outside reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

  @tc_6696
  Scenario: Verification of CPOE for Medication Orders - Alternate Stage 1 does not take into account inactive medications
    And get "all" details of "CPOE for Medication Orders - Alternate" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "0 and 1"
    When the "medication list" is "inactivated"
    Then the "denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"

    When login as "stage1 EP"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"
    When the "medication list" is "inactivated"
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

  @tc_6697
  Scenario: Verification of CPOE for Medication Orders - Alternate Stage 1 does not take into account deleted medications
    And get "all" details of "CPOE for Medication Orders - Alternate" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "0 and 1"
    When the "medication list" is "deleted"
    Then the "denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"

    When login as "stage1 EP"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

  @tc_6698
  Scenario: Verification of CPOE for Medication Orders - Alternate Stage 1 does not take into account cancelled med orders
    And get "all" details of "CPOE for Medication Orders - Alternate" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And login as "stage1 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1 and 2"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"
    When the "medication order" is cancelled for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "CPOE for Medication Orders - Alternate" numerator report under "core set"

    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "increased" by "1"
    And "a record" should be in "CPOE for Medication Orders - Alternate" numerator report under "core set"
    When the "medication order" is cancelled for the patient
    Then the "numerator and denominator" of "CPOE for Medication Orders - Alternate" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "CPOE for Medication Orders - Alternate" numerator report under "core set"