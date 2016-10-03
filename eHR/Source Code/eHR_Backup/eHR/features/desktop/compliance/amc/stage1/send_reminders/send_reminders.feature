#Name             : Send Reminders
#Description      : Covers scenarios under Send Reminders feature for stage1
#Author           : Gomathi

@all @s1_send_reminders @stage1 @milestone6
Feature: AMC - Verification of Numerator and Denominator changes - Send Reminders - Stage 1

  Background:
    Given login as "non EP"

  @tc_2734 @chrome
  Scenario: Verification of Send Reminders by Clicking EOE is not taking patient reminder preference into consideration
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    And get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1"
    And Send button "should not" be displayed for "Send Reminders"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age 5 on current date"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1"
    And Send button "should not" be displayed for "Send Reminders"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1"
    And Send button "should not" be displayed for "Send Reminders"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age 65 on current date"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1"
    And Send button "should not" be displayed for "Send Reminders"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

  @tc_3241
  Scenario: Verification of Send Reminders through Send button is not taking patient reminder preference into consideration
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    And get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age 5 on current date"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age 65 on current date"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "1 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

  @tc_3251
  Scenario: Verification of Send button should not be displayed when current date is not within reporting period
    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU and age less than 5 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should not" be displayed for "Send Reminders"

    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "2 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "outside report range"
    And a patient is created "with MU and age greater than 65 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should not" be displayed for "Send Reminders"

    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age greater than 65 and unchecked reminders"
    When "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0 and 1"
    And Send button "should" be displayed for "Send Reminders"
    When the reminder is sent for the patient from "AMC Report" page
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "2 and 0"
    And "a record" should be in "Send Reminders" numerator report under "menu set"

  @tc_6540 @chrome
  Scenario: Verification of Send Reminder (2014; EOE): Does not account visits outside RP and not considering reminder preference
    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65"
    When "1" exam is created for the patient as "1 day" "after" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

  @tc_6541 @chrome
  Scenario: Verification of Send Reminder(2014;EOE): Does not account non face to face visit and not considering reminder preference
    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65"
    When "1" exam is created for the patient as "MU unchecked" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

  @tc_6542 @chrome
  Scenario: Verification of Send Reminder(2014;EOE): Does not account Inpatient visit and not considering reminder preference
    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65"
    When "1" exam is created for the patient as "inpatient" and "1 day" "before" the reporting period
    And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

  @tc_6543
  Scenario: Verification of SendReminder(2014;EOE): Does not account Inactive visit and not considering reminder preference
    Given get "all" details of "Send Reminders" under "menu set" for "stage1 ep" as "within report range"
    And a patient is created "with MU and age less than 5"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"

    Given a patient is created "with MU and age greater than 65"
    When "1" exam is created for the patient as "inactive" and "1 day" "before" the reporting period
    Then the "numerator and denominator" of "Send Reminders" under "menu set" should be "increased" by "0"
    And "invalid record" should not be in "Send Reminders" numerator report under "menu set"
    And set "stage1 ep" as current EP