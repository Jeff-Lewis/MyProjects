#Name             : Generate Health Record
#Description      : covers scenarios of Generate Health Record under Tasks
#Author           : Gomathi

@all @tasks_generate_health_record @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate Health Record

  @tc_66
  Scenario: Verification of Patient gender is displayed against Sex field on CCD
    Given login as "non ep"
    And set EP as "stage1 ep"
    When a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And Health Record is generated for the "patient"
    Then patient "sex" details should be displayed in the Health Record