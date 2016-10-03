#Name             : Automated Measure Calculator - General
#Description      : covers scenarios under General for Automated Measure Calculator
#Author           : Gomathi

@all @amc @amc_general @milestone7
Feature: AMC - Verification of Automated Measure Calculator scenarios - General

  Background:
    Given login as "non ep"

  @tc_14
  Scenario: Verification of Correct text message of StageX: YearY displayed on AMC for EP Start year Last year and Server year Current year
    Given a "stage1 ep" is created with "last year" as "stage1 start year"
    When EP is selected from AMC page EP list
    Then "Currently reporting for stage 1 – year 2" message should be displayed

  @tc_15
  Scenario: Verification of Correct text message of StageX: YearY displayed on AMC for EP Start year Two years before and Server year Current year
    Given a "stage2 ep" is created with "two years before" as "stage1 start year"
    When EP is selected from AMC page EP list
    Then "Currently reporting for stage 2 – year 1" message should be displayed

  @tc_18
  Scenario: Verification of stage 1 AMC report Generation
    Given set EP as "stage1 ep"
    When AMC report is generated "without CQM report" for "stage1 ep" as "within report range"
    Then "stage1 AMC" report is generated
    And "No" "CQM" report is generated

  @tc_19
  Scenario: Verification of stage 2 AMC report Generation
    Given set EP as "stage2 ep"
    When AMC report is generated "without CQM report" for "stage2 ep" as "within report range"
    Then "stage2 AMC" report is generated
    And "No" "CQM" report is generated

  @tc_1810
  Scenario: Verification of AMC report for appropriate Stage can be only generated for an active Eligible Professional
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    When AMC report is generated "without CQM report" for "stage1 ep" as "within report range"
    And "stage1 ep" is "inactivated"
    Then Inactivated EP is not listed in "AMC report" EP list

  @tc_1811 @chrome
  Scenario: Verification of Inactivated Eligible Provider is not displayed on All EP AMC report
    Given a "stage1 ep" is created with "current year" as "stage1 start year"
    When AMC report is generated for "all ep" as "within report range"
    Then "stage1 ep" is listed in All EP report
    When "stage1 ep" is "inactivated"
    And AMC report is generated for "all ep" as "within report range"
    Then "stage1 ep" is not listed in All EP report

    And a "stage2 ep" is created with "two years before" as "stage1 start year"
    When AMC report is generated for "all ep" as "within report range"
    Then "stage2 ep" is listed in All EP report
    When "stage2 ep" is "inactivated"
    And AMC report is generated for "all ep" as "within report range"
    Then "stage2 ep" is not listed in All EP report

  @tc_6463
  Scenario: Verification of Stage 1 AMC report along with CQM report Generation
    Given set EP as "stage1 ep"
    When AMC report is generated "with CQM report" for "stage1 ep" as "within report range"
    Then "stage1 AMC" report is generated
    And "CQM" report is generated

  @tc_6467
  Scenario: Verification of Stage 2 AMC report along with CQM report Generation
    Given set EP as "stage2 ep"
    When AMC report is generated "with CQM report" for "stage2 ep" as "within report range"
    Then "stage2 AMC" report is generated
    And "CQM" report is generated

  @tc_6468
  Scenario: Verification of CQM Report Generation
    Given set EP as "stage1 ep"
    When AMC report is generated "with CQM report" for "stage1 ep" as "within report range"
    Then "stage1 AMC" report is generated
    And "CQM" report is generated
    And verify "Controlling High Blood Pressure (NQF0018)" objective is present under "CQM report"
    And verify "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - BMI Recorded 3-17 (NQF0024)" objective is present under "CQM report"
    And verify "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - Nutrition Counseling 3-17 (NQF0024)" objective is present under "CQM report"
    And verify "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - Physical Activity Counseling 3-17 (NQF0024)" objective is present under "CQM report"
    And verify "Preventative Care and Screening: Tobacco Use: Screening and Cessation Intervention (NQF0028)" objective is present under "CQM report"
    And verify "Breast Cancer Screening (NQF0031)" objective is present under "CQM report"
    And verify "Colorectal Cancer Screening (NQF0034)" objective is present under "CQM report"
    And verify "Childhood Immunization Status (NQF0038)" objective is present under "CQM report"
    And verify "Pneumonia Vaccination Status for Older Adults (NQF0043)" objective is present under "CQM report"
    And verify "Documentation of Current Medications in the Medical Record (NQF0419)" objective is present under "CQM report"
    And verify "Preventative Care and Screening: Body Mass Index (BMI) Screening and Follow-Up - 65+ (NQF0421)" objective is present under "CQM report"
    And verify "Preventative Care and Screening: Body Mass Index (BMI) Screening and Follow-Up - 18-64 (NQF0421)" objective is present under "CQM report"
