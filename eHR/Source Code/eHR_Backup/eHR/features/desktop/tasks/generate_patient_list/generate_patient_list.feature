#Name             : Generate Patient list
#Description      : covers scenarios of Generate Patient list under Tasks
#Author           : Gomathi

@all @tasks_generate_patient_list @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate Patient list

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_39
  Scenario: Verification of Patient list can be created based on patients Sex
    Given a patient list is generated for "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Sex" "Male" in "Generate Patient list" page
    Then patient list with "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Sex" "Male" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Sex" "Female" in "Generate Patient list" page
    Then patient list with "Sex" "Female" should be displayed in "Generate Patient list" page

  @tc_40
  Scenario: Verification of Patient list can be generated based on multiple Race value
    Given a "stage2 ep" is created with "two years before" as "stage1 start year"
    And a patient is created "with MU and race American Indian or Alaska Native"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and race Asian"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and race Black or African American"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and race Hawaiian Native or Pacific Islander"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and race White (Caucasian)"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and race Other Race"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU and All Race"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period

    When a patient list is generated for "Race" "American Indian or Alaska Native" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "American Indian or Alaska Native, Asian" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native, Asian" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "American Indian or Alaska Native, Asian, Black or African American" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native, Asian, Black or African American" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander, White (Caucasian)" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander, White (Caucasian)" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander, White (Caucasian), Other Race" in "Generate Patient list" page
    Then patient list with "Race" "American Indian or Alaska Native, Asian, Black or African American, Hawaiian Native or Pacific Islander, White (Caucasian), Other Race" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Race" "Declined to state" in "Generate Patient list" page
    Then "No" patient list with "Race" "Decline to State" should be displayed in "Generate Patient list" page

  @tc_45
  Scenario: Verification of Generate Patient List by selecting multiple fields under Demographics
    Given a patient list is generated for "Age From" "0", "Age To" "60", "Preferred Language" "English (eng)" and "Race" "American Indian or Alaska Native, Asian" in "Generate Patient list" page
    Then patient list with "Age From" "0", "Age To" "60", "Preferred Language" "English (eng)" and "Race" "American Indian or Alaska Native, Asian" should be displayed in "Generate Patient list" page

  @tc_600
  Scenario: Verification of Generate Patient list associated to an EP based on Visit Date and Time
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "at 9 AM" "1 day" "before" the reporting period
    And "1" exam is created for the patient as "active" and "at 5 PM" "1 day" "before" the reporting period
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "at 1 PM" "1 day" "before" the reporting period
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "at 7 PM" "1 day" "before" the reporting period

    When a patient list is generated for "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Exam time from" "12:00 AM" and "Exam time to" "11:59 PM" in "Generate Patient list" page
    Then patient list with "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Exam time from" "12:00 AM" and "Exam time to" "11:59 PM" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Exam time from" "12:00 AM" and "Exam time to" "05:00 PM" in "Generate Patient list" page
    Then patient list with "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Exam time from" "12:00 AM" and "Exam time to" "05:00 PM" should be displayed in "Generate Patient list" page

  @tc_622
  Scenario: Verification of Generate Patient List associated to the EP based on Medication Allergy
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication allergen with Reaction and Mild Severity" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication allergen with Reaction and Severe Severity" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication allergen" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "Gadolinium contrast material allergy" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "Iodine contrast material allergy" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "other allergy" is created "within reporting period" under "health status"

    When a patient list is generated for "Allergen" "Gadolinium contrast material" in "Generate Patient list" page
    Then patient list with "Allergen" "Gadolinium contrast material" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Allergen" "Iodine contrast material" in "Generate Patient list" page
    Then patient list with "Allergen" "Iodine contrast material" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Allergen" "Medication", "Medication Allergy" "Iron" in "Generate Patient list" page
    Then patient list with "Allergen" "Medication", "Medication Allergy" "Iron" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Allergen" "Medication", "Medication Allergy" "Iron", "Reaction" "Cardiac arrest" in "Generate Patient list" page
    Then patient list with "Allergen" "Medication", "Medication Allergy" "Iron", "Reaction" "Cardiac arrest" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Allergen" "Other" in "Generate Patient list" page
    Then patient list with "Allergen" "Other" should be displayed in "Generate Patient list" page

  @tc_623
  Scenario: Verification of Generate Patient List associated to the EP based on preferred method of confidential communication
    Given a patient is created "with MU" and preferred method of confidential communication as "Face to Face"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU" and preferred method of confidential communication as "Phone"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU" and preferred method of confidential communication as "Email"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU" and preferred method of confidential communication as "Alternate"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a patient is created "with MU" and preferred method of confidential communication as "Secure Messaging"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period

    When a patient list is generated for "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Preferred method of confidential communication" "Secure Messaging" in "Generate Patient list" page
    Then patient list with "Exam date from" "Yesterday", "Exam date to" "Yesterday", "Preferred method of confidential communication" "Secure Messaging" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Preferred method of confidential communication" "Face to Face" in "Generate Patient list" page
    Then patient list with "Preferred method of confidential communication" "Face to Face" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Preferred method of confidential communication" "Phone" in "Generate Patient list" page
    Then patient list with "Preferred method of confidential communication" "Phone" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Preferred method of confidential communication" "Email" in "Generate Patient list" page
    Then patient list with "Preferred method of confidential communication" "Email" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Preferred method of confidential communication" "Alternate" in "Generate Patient list" page
    Then patient list with "Preferred method of confidential communication" "Alternate" should be displayed in "Generate Patient list" page

  @tc_753
  Scenario: Verification of Generate Patient List associated to the EP based on Problems
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded problem list" is created "within reporting period" under "health status"

    When a patient list is generated for "Problem" "268519009 - Diabetic - poor control (finding)" in "Generate Patient list" page
    Then patient list with "Problem" "268519009 - Diabetic - poor control (finding)" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)" in "Generate Patient list" page
    Then patient list with "Problem" "39155009 - Hypertension education (procedure)" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Inactive" in "Generate Patient list" page
    Then patient list with "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Inactive" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Active" in "Generate Patient list" page
    Then patient list with "Problem" "39155009 - Hypertension education (procedure)", "Problem status" "Active" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Problem from date" "start date of year", "Problem to date" "today" in "Generate Patient list" page
    Then patient list with "Problem from date" "start date of year", "Problem to date" "today" should be displayed in "Generate Patient list" page

  @tc_754
  Scenario: Verification of Generate Patient List associated to an EP based on Medications
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "coded medication list" is created "within reporting period" under "health status"

    When a patient list is generated for "Medication" "ZyrTEC (Oral Pill) 5 mg" in "Generate Patient list" page
    Then patient list with "Medication" "ZyrTEC (Oral Pill) 5 mg" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Medication" "Simvastatin (Oral Pill) 40 mg" in "Generate Patient list" page
    Then patient list with "Medication" "Simvastatin (Oral Pill) 40 mg" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Medication" "Simvastatin (Oral Pill) 40 mg", "Medication status" "Inactive" in "Generate Patient list" page
    Then patient list with "Medication" "Simvastatin (Oral Pill) 40 mg", "Medication status" "Inactive" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Medication" "Simvastatin (Oral Pill) 40 mg", "Medication status" "Active" in "Generate Patient list" page
    Then patient list with "Medication" "Simvastatin (Oral Pill) 40 mg", "Medication status" "Active" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Medication from date" "start date of year", "Medication to date" "today" in "Generate Patient list" page
    Then patient list with "Medication from date" "start date of year", "Medication to date" "today" should be displayed in "Generate Patient list" page

  @tc_755
  Scenario: Verification of Generate patient List associated to an EP based on Lab Results & values
    Given a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And "1" "laboratory order" is placed "within reporting period" for the patient
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
    And a patient is created "with MU"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient

    When a patient list is generated for "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood" in "Generate Patient list" page
    Then patient list with "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "greater than 20" in "Generate Patient list" page
    Then patient list with "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "greater than 20" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "less than 20" in "Generate Patient list" page
    Then patient list with "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "less than 20" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "equal to 15" in "Generate Patient list" page
    Then patient list with "Lab Test" "30313-1 - Hemoglobin [Mass/volume] in Arterial blood", "Lab Result" "equal to 15" should be displayed in "Generate Patient list" page
    When a patient list is generated for "Lab Result from date" "start date of year", "Lab Result to date" "today" in "Generate Patient list" page
    Then patient list with "Lab Result from date" "start date of year", "Lab Result to date" "today" should be displayed in "Generate Patient list" page


