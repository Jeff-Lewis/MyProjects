#Name             : Demographics
#Description      : covers scenarios under Demographics feature for stage2
#Author           : Gomathi

@all @s2_demographics @stage2 @milestone1
Feature: AMC - Verification of Numerator and Denominator changes - Demographics - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_192 @tc_help_text
  Scenario: Verification of Help text and Requirement for Stage 2 Demographics AMC measure
    When get "requirement" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "demographics" under "core set" should be "equal" to "80"
    When get help text of "demographics" under "core set" from tooltip
    Then help text for "demographics" should be equal to the text
    """
    More than 80 percent of all unique patient's seen by the EP have demographics recorded as structured data.
    """

  @tc_4789
  Scenario: Negative Scenarios of Demographics objective in Stage 2 AMC measure
    Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "without MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "denominator" of "demographics" under "core set" should be "increased" by "1"
    When patient "sex" is updated in demographics tab
    Then the "numerator" of "demographics" under "core set" should be "increased" by "0"
    When patient "ethnicity" is updated in demographics tab
    Then the "numerator" of "demographics" under "core set" should be "increased" by "0"
    When patient "preferred language" is updated in demographics tab
    Then the "numerator" of "demographics" under "core set" should be "increased" by "0"
    When patient "race" is updated in demographics tab
    Then the "numerator" of "demographics" under "core set" should be "increased" by "1"
	Then "a record" should be in "demographics" numerator report under "core set"

  @tc_4788
  Scenario: Positive Scenarios of Demographics objective in Stage 2 AMC measure
  	Then get "all" details of "demographics" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"

    When get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
	And "a record" should be in "demographics" numerator report under "core set"

  @tc_4787
  Scenario: Verification of Demographics objective in Stage 2 AMC measure does not take into account patients with Inactive visits
  	Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "demographics" under "core set" should be "decreased" by "1"
	And "invalid record" should not be in "demographics" numerator report under "core set"

  @tc_4786
  Scenario: Verification of Demographics objective in Stage 2 AMC measure does not take into account Inpatients
  	Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	And "a record" should be in "demographics" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "demographics" under "core set" should be "decreased" by "1"
	And "invalid record" should not be in "demographics" numerator report under "core set"

  @tc_4785
  Scenario: Verification of Demographics objective in Stage 2 AMC measure does not take into account Non face-to-face patients
  	Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "1"
  	Then "a record" should be in "demographics" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "demographics" under "core set" should be "decreased" by "1"
	Then "invalid record" should not be in "demographics" numerator report under "core set"

  @tc_4784
  Scenario: Verification of Demographics objective in  Stage 2 AMC measure does not take into account patients seen Outside reporting period
  	Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "1 day" "after" the reporting period
    Then the "numerator and denominator" of "demographics" under "core set" should be "increased" by "0"
	Then "invalid record" should not be in "demographics" numerator report under "core set"