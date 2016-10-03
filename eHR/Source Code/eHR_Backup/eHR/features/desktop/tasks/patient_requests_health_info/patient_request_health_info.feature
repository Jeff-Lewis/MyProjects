#Name             : Patient Request Health Information
#Description      : covers scenarios of Patient Request Health Information under Tasks
#Author           : Gomathi

@all @tasks_patient_request_health_information @tasks @milestone9 @chrome
Feature: Tasks - Verification of Tasks Scenarios - Patient Request Health Information

  Background:
    Given login as "non ep"

  @tc_981
  Scenario: Verification of Download CCDA Clinical Summary
    Given a patient is created "with MU"
    When Health Record is generated for the "patient"
    Then CCDA Clinical Summary is downloaded

  @tc_6694
  Scenario: Verification of Log Records are added on Patient Requests Health Information page after generating a new phr
    Given set EP as "stage1 ep"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And Health Record is generated for the "patient" "with patient request" and "request date" as "future date"
    Then "Report Requested Date should be less than or equal to current date" message should be displayed
    When Health Record is generated for the "patient" "with patient request"
    Then "a record" should be added for Requested date and Delivered date
    And Health Record is generated for the "visit" "with patient request"
    Then "a record" should be added for Requested date and Delivered date