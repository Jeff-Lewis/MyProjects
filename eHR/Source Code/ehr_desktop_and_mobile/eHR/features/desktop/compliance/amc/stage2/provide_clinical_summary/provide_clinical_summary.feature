#Name             : Provide Clinical Summary
#Description      : Covers scenarios under Provide Clinical Summary feature for stage2
#Author           : Gomathi

@all @s2_provide_clinical_summary @stage2 @milestone3
Feature: AMC - Verification of Numerator and Denominator changes - Provide Clinical Summary - Stage 2

  Background:
    Given login as "non EP"
    
  @tc_498 @tc_help_text
  Scenario: Verification of Help text and Threshold value for Provide Clinical Summary AMC stage 2 measure
    When get "requirement" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    Then the "requirement" of "Provide Clinical Summary" under "core set" should be "equal" to "50"
    When get help text of "Provide Clinical Summary" under "core set" from tooltip
    Then help text for "Provide Clinical Summary" should be equal to the text
    """
    Clinical summaries provided to patients for more than 50 % of all office visits within 1 business day
    """

  @tc_500 @chrome
  Scenario: Verification of Positive scenarios with exam on weekdays in Provide Clinical Summary AMC stage 2 measure
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "12 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "23 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "9 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    And "1" exam is created as "active" "13 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created as "active" "23:50" "on" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    # EOE generated outside reporting period
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1826_1 @chrome
  Scenario: Verification of Positive scenarios considering exams on Weekends in Provide Clinical Summary Stage 2 AMC measure - on saturday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "52 hours" "before" the reporting period and "on saturday"
    # monday 4 am - tuesday 3.59 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1826_2 @chrome
  Scenario: Verification of Positive scenarios considering exams on Weekends in Provide Clinical Summary Stage 2 AMC measure - on saturday & sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "71 hours" "before" the reporting period and "on saturday"
    # monday 11 pm - tuesday 11 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "47 hours" "before" the reporting period and "on sunday"
    # monday 11 pm - tuesday 11 pm
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1826_3 @chrome
  Scenario: Verification of Positive scenarios considering exams on Weekends in Provide Clinical Summary Stage 2 AMC measure - on sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "25 hours" "before" the reporting period and "on sunday"
    # monday 1 am - tuesday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1826_4 @chrome
  Scenario: Verification of Positive scenarios considering exams on Weekends in Provide Clinical Summary Stage 2 AMC measure - 60 hours & friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "60 hours" "before" the reporting period and "on friday"
    #SUNDAY 12 PM - MONDAY 12 PM
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1826_5 @chrome
  Scenario: Verification of Positive scenarios considering exams on Weekends in Provide Clinical Summary Stage 2 AMC measure - 71 hours & friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "71 hours" "before" the reporting period and "on friday"
    #SUNDAY 11 PM - MONDAY 11 PM
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1827_1 @chrome
  Scenario: Verification of Positive scenario with exam created on US Federal Holidays in Provide Clinical Summary Stage 2 AMC measure - 25 hours
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "25 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_1827_2 @chrome
  Scenario: Verification of Positive scenario with exam created on US Federal Holidays in Provide Clinical Summary Stage 2 AMC measure - 47 hours
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "47 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6678 @chrome
  Scenario: Verification of Stage 2 Provide Clinical Summary does not take into account exams created outside reporting period
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "outside report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "24 hours" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6679 @chrome
  Scenario: Verification of Stage 2 Provide Clinical Summary does not take into account patient with non face-to-face visits
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "MU unchecked" and "22 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "22 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6680 @chrome
  Scenario: Verification of Stage 2 Provide Clinical Summary does not take into account patient with Inpatient visit
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "inpatient" and "22 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "22 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6681 @chrome
  Scenario: Verification of Stage 2 Provide Clinical Summary does not take into account patient with Inactive visit
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "22 hours" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6682_1 @chrome
  Scenario: Verification of Negative scenario with exam created on US Federal Holidays in Provide Clinical Summary Stage 2 AMC measure - on US Federal Holiday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "49 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "48.5 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6682_2 @chrome
  Scenario: Verification of Negative scenario with exam created on US Federal Holidays in Provide Clinical Summary Stage 2 AMC measure - 1 day prior to US Federal Holiday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "49 hours" "before" the reporting period and "1 day prior to US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6683_1 @chrome
  Scenario: Verification of Negative scenarios with exams on weekends in Provide Clinical Summary stage 2 AMC measure - on saturday & sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "73 hours" "before" the reporting period and "on saturday"
    # tuesday 1 am - wednesday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "49 hours" "before" the reporting period and "on sunday"
    # tuesday 1 am - wednesday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6683_2 @chrome
  Scenario: Verification of Negative scenarios with exams on weekends in Provide Clinical Summary stage 2 AMC measure - on friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "73 hours" "before" the reporting period and "on friday"
    # monday 1 am - tuesday 1 am
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6684 @chrome
  Scenario: Verification of Negative scenarios with exams created on weekdays in Provide Clinical Summary stage 2 AMC measure
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage2 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "25 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "24.5 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"



