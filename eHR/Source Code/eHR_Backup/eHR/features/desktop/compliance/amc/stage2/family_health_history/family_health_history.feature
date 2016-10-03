#Name             : Family health history
#Description      : covers scenarios under Family health history feature for stage2
#Author           : Gomathi

@all @s2_family_history @stage2 @milestone1
Feature: AMC - Verification of Numerator and Denominator changes - Family Health History - Stage 2

  Background:
    Given login as "non ep"
    
  @tc_396 @tc_help_text
  Scenario: Verification of Help text and Requirement for Family Health History AMC measure
    And get "requirement" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    Then the "requirement" of "family health history" under "menu set" should be "equal" to "20"
    When get help text of "family health history" under "menu set" from tooltip
    Then help text for "family health history" should be equal to the text
    """
    More than 20 percent of all unique patients seen by the EP during the EHR reporting period have a structured data entry for one or more first-degree relatives.
    """

  @tc_4796
  Scenario: Verification of Family Health History objective in Stage 2 AMC measure does not take into account Inpatients
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

  @tc_4797
  Scenario: verification of Family Health History objective in stage 2 AMC measure does not take into account patients with inactive status
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

  @tc_4794
  Scenario: Verification of Family Health History objective in stage 2 AMC measure does not take into account for patients seen outside reporting period
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

  @tc_4795
  Scenario: Verification of Family Health History objective in stage 2 AMC measure does not take into account for non face-to-face patients
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

  @tc_5754
  Scenario: Verification of Family Health History stage 2 AMC measure - patient with More than 1 visit
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "family health history" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And "1" "uncoded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "family health history" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And "1" "none known family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "family health history" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "family health history" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "0"

  @tc_5752
  Scenario: Verification of Family Health History objective in stage 2 AMC measure - None Known
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When get "all" details of "family health history" under "menu set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "none known family history" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

  @tc_402
  Scenario: Verification of Family Health History objective in stage 2 AMC measure - Coded Family History
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "2" "coded family history" are created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When get "all" details of "family health history" under "menu set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

  @tc_5753
  Scenario:  Verification of Family Health History objective in stage 2 AMC measure - Uncoded Family History
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "2" "uncoded family history" are created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

    When get "all" details of "family health history" under "menu set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded family history" is created "outside reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"

  @tc_5755
  Scenario: Verification of Family health History objective in Stage 2 does not take into account deleted Family History
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the "family history" is "deleted"
    Then the "numerator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the "family history" is "deleted"
    Then the "numerator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

  @tc_2184
  Scenario: Verification of Family Health History Stage 2 AMC measure does not take into account Inactive Family History
    Then get "all" details of "family health history" under "menu set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the "family history" is "inactivated"
    Then the "numerator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "uncoded family history" is created "within reporting period" under "health status"
    Then the "numerator and denominator" of "family health history" under "menu set" should be "increased" by "1"
    And "a record" should be in "family health history" numerator report under "menu set"
    When the "family history" is "inactivated"
    Then the "numerator" of "family health history" under "menu set" should be "decreased" by "1"
    And "invalid record" should not be in "family health history" numerator report under "menu set"