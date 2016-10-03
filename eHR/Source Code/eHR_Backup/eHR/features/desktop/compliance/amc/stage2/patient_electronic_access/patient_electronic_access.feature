#Name             : Patient Electronic Access
#Description      : Covers scenarios under Patient Electronic Access feature for stage2
#Author           : Gomathi

@all @s2_patient_electronic_access @stage2 @milestone3
Feature: AMC - Verification of Numerator and Denominator changes - Patient Electronic Access - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_4244 @tc_help_text
  Scenario: Verification of Help text and requirement column for Patient Electronic Access Stage 2 AMC measure
    When get "requirement" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Patient Electronic Access" under "core set" should be "equal" to "50"
    When get help text of "Patient Electronic Access" under "core set" from tooltip
    Then help text for "Patient Electronic Access" should be equal to the text
    """
    More than 50 percent of all unique patients seen by the EP during the EHR reporting period and are provided timely (available to the patient within 4 business days after the information is available to the EP) online access to their health information
    """

  @tc_4236 @chrome
  Scenario: Verification of Positive scenarios in Patient Electronic Access Stage 2 AMC measure (only considering exams on weekdays)
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "36 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "48 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "60 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "72 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "92 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "95.5 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_4245 @chrome
  Scenario: Verification of Negative scenarios in Patient Electronic Access Stage 2 AMC measure ( exam on weekdays )
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "96.5 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "97 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_4246 @chrome
  Scenario: Verification of Patient Electronic Access Stage 2 measure does not account visits outside reporting period
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And ensure "24 hours" "after" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "24 hours" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_4247 @chrome
  Scenario: Verification of Patient Electronic Access Stage 2 does not take into account visits with "Count for MU" unchecked
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And ensure "24 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "MU unchecked" and "24 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And ensure "24 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "active" and "24 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_4248 @chrome
  Scenario: Verification of Patient Electronic Access Stage 2 measure does not take into account Inpatient patients
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And ensure "50 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "inpatient" and "50 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And ensure "48 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "active" and "48 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_4249 @chrome
  Scenario: Verification of Patient Electronic Access Stage 2 measure does not consider inactive visits
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And ensure "72 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "inactive" and "72 hours" "before" the reporting period
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And ensure "80 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    And "1" exam is created for the patient as "active" and "80 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_6598_1 @chrome
  Scenario: Verification of Positive scenarios considering weekends in Patient Electronic Access Stage 2 AMC measure - 124 hours
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "124 hours" "before" the reporting period and "on saturday"
    # thursday 4 am - friday 3.59 AM
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6598_2 @chrome
  Scenario: Verification of Positive scenarios considering weekends in Patient Electronic Access Stage 2 AMC measure - 143.5 hours & 119.5 hours
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "143.5 hours" "before" the reporting period and "on saturday"
    # thursday 11.30 PM - friday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "119.5 hours" "before" the reporting period and "on sunday"
    # thursday 11.30pm- friday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6598_3 @chrome
  Scenario: Verification of Positive scenarios considering weekends in Patient Electronic Access Stage 2 AMC measure - 105 hours
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "105 hours" "before" the reporting period and "on sunday"
    # thursday 9 am- friday 8.59 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6598_4 @chrome
  Scenario: Verification of Positive scenarios considering weekends in Patient Electronic Access Stage 2 AMC measure - 143.5 hours
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "143.5 hours" "before" the reporting period and "on thursday"
    # tuesday 11.30 pm - wednesday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6603_1 @chrome
  Scenario: Verification of Positive scenarios considering US Federal Holidays in Patient Electronic Access Stage 2 AMC measure - on US Federal Holiday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "119.5 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6603_2 @chrome
  Scenario: Verification of Positive scenarios considering US Federal Holidays in Patient Electronic Access Stage 2 AMC measure - 2 days prior to US Federal Holiday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "119.5 hours" "before" the reporting period and "2 days prior to US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_6676_1 @chrome
  Scenario: Verification of Negative scenarios only considering exam on weekends in Patient Electronic Access Stage 2 AMC measure - on saturday & sunday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "144.5 hours" "before" the reporting period and "on saturday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "145 hours" "before" the reporting period and "on saturday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "120.5 hours" "before" the reporting period and "on sunday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "121 hours" "before" the reporting period and "on sunday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_6676_2 @chrome
  Scenario: Verification of Negative scenarios only considering exam on weekends in Patient Electronic Access Stage 2 AMC measure - on thursday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "144.5 hours" "before" the reporting period and "on thursday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_6677_1 @chrome
  Scenario: Verification of Negative scenarios with exam on US Federal Holidays in Patient Electronic Access Stage 2 AMC measure - on US Federal Holiday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "121 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_6677_2 @chrome
  Scenario: Verification of Negative scenarios with exam on US Federal Holidays in Patient Electronic Access Stage 2 AMC measure - 2 days prior to US Federal Holiday
    Then get "all" details of "Patient Electronic Access" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "120.5 hours" "before" the reporting period and "2 days prior to US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"