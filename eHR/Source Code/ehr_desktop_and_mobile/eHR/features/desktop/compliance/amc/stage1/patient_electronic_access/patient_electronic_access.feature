#Name             : Patient Electronic Access
#Description      : Covers scenarios under Patient Electronic Access feature for stage1
#Author           : Gomathi

@all @s1_patient_electronic_access @stage1 @milestone6
Feature: AMC - Verification of Numerator and Denominator changes - Patient Electronic Access - Stage 1

  Background:
    Given login as "non EP"

  @tc_7681 @tc_help_text
  Scenario: Verification of Help text and requirement column for Patient Electronic Access Stage 1 AMC measure
    Given get "requirement" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Patient Electronic Access" under "core set" should be "equal" to "50"
    When get help text of "Patient Electronic Access" under "core set" from tooltip
    Then help text for "Patient Electronic Access" should be equal to the text
    """
    More than 50 percent of all unique patients seen by the EP during the EHR reporting period are provided timely (available to the patient within 4 business days after the information is available to the EP) online access to their health information, with the ability to view, download, and transmit to a third party.
    """

  @tc_7680 @chrome
  Scenario: Verification of Positive scenarios only considering exams on Weekdays in Patient Electronic Access Stage 1 AMC measure
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "36 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "48 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "60 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "72 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "92 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "95.5 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7682 @chrome
  Scenario: Verification of Negative scenarios only considering exams on Weekdays in Patient Electronic Access Stage 1 AMC measure
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "96.5 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "97 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7683 @chrome
  Scenario: Verification of Patient Electronic Access Stage 1 AMC measure does not account for visits outside reporting period
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    And ensure "24 hours" "after" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "24 hours" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7684 @chrome
  Scenario: Verification of Patient Electronic Access Stage 1 does not take into account visits with "Count for MU" unchecked
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And ensure "24 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "MU unchecked" and "24 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    And ensure "24 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "active" and "24 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7685 @chrome
  Scenario: Verification of Patient Electronic Access Stage 1 measure does not take into account Inpatient visits
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And ensure "50 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "inpatient" and "50 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    And ensure "48 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "active" and "48 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7686 @chrome
  Scenario: Verification of Patient Electronic Access Stage 1 does not consider inactive visits
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    And ensure "72 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "inactive" and "72 hours" "before" the reporting period
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    And ensure "80 hours" "before" the reporting period is not a Week end and not a US Federal Holiday
    When "1" exam is created for the patient as "active" and "80 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7687_1 @chrome
  Scenario: Verification of Positive scenarios considering exams on weekends in Patient Electronic Access Stage 1 AMC measure - Saturday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "124 hours" "before" the reporting period and "on saturday"
  # thursday 4 am - friday 3.59 AM
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7687_2 @chrome
  Scenario: Verification of Positive scenarios considering exams on weekends in Patient Electronic Access Stage 1 AMC measure - Sunday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "105 hours" "before" the reporting period and "on sunday"
  # thursday 9 am- friday 8.59 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7687_3 @chrome
  Scenario: Verification of Positive scenarios considering exams on weekends in Patient Electronic Access Stage 1 AMC measure - Saturday & Sunday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "143.5 hours" "before" the reporting period and "on saturday"
  # thursday 11.30 PM - friday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "119.5 hours" "before" the reporting period and "on sunday"
  # thursday 11.30 PM - friday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7687_4 @chrome
  Scenario: Verification of Positive scenarios considering exams on weekends in Patient Electronic Access Stage 1 AMC measure - Thursday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "143.5 hours" "before" the reporting period and "on thursday"
  # tuesday 11.30 pm - wednesday 11.29 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7688_1 @chrome
  Scenario: Verification of Positive scenario considering US Federal Holidays in Patient Electronic Access Stage 1 AMC measure - on US Federal Holiday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "119.5 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7688_2 @chrome
  Scenario: Verification of Positive scenario considering US Federal Holidays in Patient Electronic Access Stage 1 AMC measure - 2 days prior to us federal holiday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "119.5 hours" "before" the reporting period and "2 days prior to us federal holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "1"
    And "a record" should be in "Patient Electronic Access" numerator report under "core set"

  @tc_7689_1 @chrome
  Scenario: Verification of Negative scenarios considering exams on Weekends in Patient Electronic Access Stage 1 AMC measure - Saturday(144.5 hours) & Sunday(120.5 hours)
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "144.5 hours" "before" the reporting period and "on saturday"
  # friday 12.30 am - saturday 12.29 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "120.5 hours" "before" the reporting period and "on sunday"
  # friday 12.30 am - saturday 12.29 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7689_2 @chrome
  Scenario: Verification of Negative scenarios considering exams on Weekends in Patient Electronic Access Stage 1 AMC measure - Saturday(145 hours) & Sunday(121 hours)
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "145 hours" "before" the reporting period and "on saturday"
  # friday 1 am - saturday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

    Given a patient is created "with MU"
    When "1" exam is created as "active" "121 hours" "before" the reporting period and "on sunday"
  # friday 1 am - saturday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7689_3 @chrome
  Scenario: Verification of Negative scenarios considering exams on Weekends in Patient Electronic Access Stage 1 AMC measure - Thursday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "144.5 hours" "before" the reporting period and "on thursday"
  # wednesday 12.30 am - thursday 12.29 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7690_1 @chrome
  Scenario: Verification of Negative scenario with exams on US Federal Holidays in Patient Electronic Access Stage 1 AMC measure - on US Federal Holiday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "121 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"

  @tc_7690_2 @chrome
  Scenario: Verification of Negative scenario with exams on US Federal Holidays in Patient Electronic Access Stage 1 AMC measure - 2 days prior to us federal holiday
    Given get "all" details of "Patient Electronic Access" under "core set" for "stage1 ep" as "within report range"
    And a patient is created "with MU"
    When "1" exam is created as "active" "120.5 hours" "before" the reporting period and "2 days prior to us federal holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Patient Electronic Access" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Patient Electronic Access" numerator report under "core set"