#Name             : CPOE for Medication orders
#Description      : covers scenarios under CPOE for Medication orders feature for stage2
#Author           : Chandra sekaran

@all @s2_cpoe_for_medication_orders @stage2 @milestone1
Feature: AMC - Verification of Numerator and Denominator changes - CPOE for Medication Orders - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_5805 @tc_help_text
  Scenario: Verify Help text and Requirement column value for CPOE for Medications Orders stage2 AMC
    Then get "requirement" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    And the "requirement" of "CPOE for Medication Order" under "core set" should be "equal" to "60"
    And get help text of "CPOE for Medication Order" under "core set" from tooltip
    And help text for "CPOE for Medication Order" should be equal to the text
    """
    More than 60 percent of medication, 30 percent of laboratory, and 30 percent of radiology orders created by the EP during the EHR reporting period are recorded using CPOE.
    """

  @tc_5794
  Scenario: CPOE for Medication Orders measure does not take into account cancelled medication orders
    Given login as "stage2 EP"
    And currently in "AMC" page
    Then get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 100
    And "a record" should be in "CPOE for Medication Order" numerator report under "core set"
    When the "medication order" is cancelled for the patient
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "decreased" by "1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0
    And "cancelled record" should not be in "CPOE for Medication Order" numerator report under "core set"

  @tc_221
  Scenario: CPOE for Medication Orders measure does not take into account deleted medications
    Then get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "0 and 1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0
    When the "medication list" is "deleted"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "decreased" by "0 and 1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0

  @tc_5793
  Scenario: CPOE Medications does not take into account Inactive Medications on Health Status tab
    Then get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "0 and 1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0
    When the "medication list" is "inactivated"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "decreased" by "0 and 1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0

  @tc_703
  Scenario: CPOE Medications does not take into account Medications outside reporting period on Health Status tab
    Then get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "0 and 1"

    When a patient is created "with MU"
    And "2" "coded medication list" are created "within reporting period" under "health status"
    Then the "numerator" of "CPOE for Medication Order" under "core set" should be "increased" by "0 and 2"

    When get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "2" "coded medication list" are created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "0"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 0

  @tc_704
  Scenario: Verify numerator value for CPOE for medication orders takes into account number of medication orders created by stage2 EP
    Then get "all" details of "CPOE for Medication Order" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "within reporting period" under "health status"
    Then the "denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "1"
    And login as "stage2 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    When a patient is created "with MU"
    And "2" "coded medication list" are created "within reporting period" under "health status"
    Then the "numerator and denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "1 and 3"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator" of "CPOE for Medication Order" under "core set" should be "increased" by "1"
    When a patient is created "with MU"
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator" of "CPOE for Medication Order" under "core set" should be "increased" by "1"
    And login as "non EP"
    When a patient is created "with MU"
    And "1" "coded medication list" is created "outside reporting period" under "health status"
    Then the "denominator" of "CPOE for Medication Order" under "core set" should be "increased" by "3"
    And login as "stage2 EP"
    And the latest patient record is selected
    And "1" "hand written medication order" is placed "within reporting period" for the patient
    Then the "numerator" of "CPOE for Medication Order" under "core set" should be "increased" by "1"
    #Then the "percentage" of "CPOE for Medication Order" under "core set" should be "equal" to 57.143
    And "a record" should be in "CPOE for Medication Order" numerator report under "core set"