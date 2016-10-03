#Name             : Provide Clinical Summary
#Description      : Covers scenarios under Provide Clinical Summary feature for stage1
#Author           : Gomathi

@all @s1_provide_clinical_summary @stage1 @milestone5
Feature: AMC - Verification of Numerator and Denominator changes - Provide Clinical Summary - Stage 1

  Background:
    Given login as "non EP"
    
  @tc_3434 @tc_help_text
  Scenario: Verification of Help text and Threshold value for Provide Clinical Summary stage 1 AMC measure
    When get "requirement" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    Then the "requirement" of "Provide Clinical Summary" under "core set" should be "equal" to "50"
    When get help text of "Provide Clinical Summary" under "core set" from tooltip
    Then help text for "Provide Clinical Summary" should be equal to the text
    """
    Clinical summaries provided to patients for more than 50 % of all office visits within 3 business days
    """

  @tc_4762 @chrome
  Scenario: Verification of Provide Clinical Summary Stage 1 AMC measure does not account visits outside reporting period
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "outside report range"
    And ensure "24 hours" "after" the reporting period is not a Week end and not a US Federal Holiday
    When a patient is created "with MU"
    And "1" exam is created as "24 hours" "after" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_4763 @chrome
  Scenario: Verification of Provide Clinical Summary Stage 1 AMC measure does not account non Face-to-Face patients
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "MU unchecked" "60 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "MU unchecked"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_4764 @chrome
  Scenario: Verification of Provide Clinical Summary Stage 1 AMC measure does not account Inpatients
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "inpatient" "48 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "inpatient"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_4765 @chrome
  Scenario: Verification of Provide Clinical Summary Stage 1 AMC measure does not account inactive visits
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "inactive" "36 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "36 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    When the exam is updated as "inactive"
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "decreased" by "1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_4766 @chrome
  Scenario: Verification of Positive scenarios with exam on weekdays in Provide Clinical Summary AMC stage 1 measure
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "36 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "48 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "60 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "71 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    And "1" exam is created as "active" "48 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"
    And "1" exam is created as "active" "50 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

    When get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU"
    And "1" exam is created as "active" "24 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_4767 @chrome
  Scenario: Verification of Negative scenarios with exam on weekdays in Provide Clinical Summary AMC stage 1 measure
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "73 hours" "before" the reporting period and "not in Week end or US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_1 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 96 hours & saturday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # wednesday
    And "1" exam is created as "active" "96 hours" "before" the reporting period and "on saturday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_2 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 110 hours & saturday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # wednesday 2 pm - thursday 2 pm
    And "1" exam is created as "active" "110 hours" "before" the reporting period and "on saturday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_3 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 80 hours & sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # wednesday 8 am - thursday 8 am
    And "1" exam is created as "active" "80 hours" "before" the reporting period and "on sunday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_4 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 95 hours & sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # wednesday 11 pm - thursday 11 pm
    And "1" exam is created as "active" "95 hours" "before" the reporting period and "on sunday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_5 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 85 hours & friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # monday 1 pm - tuesday 1 pm
    And "1" exam is created as "active" "85 hours" "before" the reporting period and "on friday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6725_6 @chrome
  Scenario: Verification of Positive scenarios with exam on Weekends in Provide Clinical Summary AMC stage 1 measure - 119 hours & friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # tuesday 11 pm - wednesday 11 pm
    And "1" exam is created as "active" "119 hours" "before" the reporting period and "on friday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6726_1 @chrome
  Scenario: Verification of Positive scenarios with exam on US Federal Holidays in Provide Clinical Summary AMC stage 1 measure - 80 hours
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "80 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6726_2 @chrome
  Scenario: Verification of Positive scenarios with exam on US Federal Holidays in Provide Clinical Summary AMC stage 1 measure - 95 hours
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "95 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "1"
    And "a record" should be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6727_1 @chrome
  Scenario: Verification of Negative scenarios with exams on Weekends in Provide Clinical Summary Stage 1 AMC measure - on Saturday & sunday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # thursday 1 am - friday 1 am
    And "1" exam is created as "active" "121 hours" "before" the reporting period and "on saturday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

    When a patient is created "with MU"
    # thursday 1 am - friday 1 am
    And "1" exam is created as "active" "97 hours" "before" the reporting period and "on sunday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6727_2 @chrome
  Scenario: Verification of Negative scenarios with exams on Weekends in Provide Clinical Summary Stage 1 AMC measure - on friday
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    # wednesday 1 am - thursday 1 am
    And "1" exam is created as "active" "121 hours" "before" the reporting period and "on friday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"

  @tc_6728 @chrome
  Scenario: Verification of Negative scenarios with exams on US Federal Holiday in Provide Clinical Summary Stage 1 AMC measure
    Then get "all" details of "Provide Clinical Summary" under "core set" for "stage1 ep" as "within report range"
    When a patient is created "with MU"
    And "1" exam is created as "active" "97 hours" "before" the reporting period and "on US Federal Holiday"
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Provide Clinical Summary" under "core set" should be "increased" by "0 and 1"
    And "invalid record" should not be in "Provide Clinical Summary" numerator report under "core set"