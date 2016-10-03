=begin
  *Name               : SendPatientReminders
  *Description        : class that holds methods for sending reminder mails for patient
  *Author             : Chandra sekaran
  *Creation Date      : 11/03/2014
  *Modification Date  :
=end

module EHR
  class SendPatientReminders

    include PageObject
    include PageUtils
    include Pagination

    text_field(:textfield_reporting_period,                 :id    => "felix-widget-calendar-FromDOE-input")
    button(:button_search,                                  :id    => "lnkReminderSearch-button")

    # objects of send reminder table
    div(:div_patient_reminder_list,                        :id    => "cntPatientReminderList")
    table(:table_patient_reminder_list,                    :xpath => "//div[@id='cntPatientReminderList']/table")
    button(:button_send_reminder,                          :id    => "lnkSendSelectedReminder-button")

    # description          : invoked automatically when page class object is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      create_hash
    end

    # description          : create hash for indexing patient reminder list table
    # Author               : Chandra sekaran
    #
    def create_hash
      @hash_patient_reminder_list_table = {
          :TASK => 1,
          :LAST_NAME => 2,
          :FIRST_NAME => 3,
          :PATIENT_ID => 4,
          :DATE_OF_BIRTH => 5,
          :PREFERRED_PHONE_NO => 6,
          :SEX => 7,
          :STATUS => 8
      }
    end

    # description          : sends reminder mail for the given patient ID
    # Author               : Chandra sekaran
    # Argument             :
    #   str_patient_id     : patient ID
    # Return argument      : a boolean value
    #
    def send_reminder(str_patient_id)
      begin
        generate_report

        bool_patient_exists, num_index = is_patient_exists(str_patient_id)

        raise "No record found for patient(#{str_patient_id}) in Send Patient Reminder report table" if !bool_patient_exists

        table_patient_reminder_list_element.checkbox_element(:xpath => "./tbody[@class='yui-dt-data']/tr[#{num_index+1}]/td[#{@hash_patient_reminder_list_table[:TASK]}]/div/input").click
        ##sleep 3
        div_copy_right_element.scroll_into_view rescue Exception
        button_send_reminder_element.click
        wait_for_loading

        # block for resending reminder if the patient record exists even after sending reminder
=begin
        bool_patient_exists, num_index = is_patient_exists(str_patient_id)
        num_max = 5  # for breaking the iteration
        while bool_patient_exists
          table_patient_reminder_list_element.checkbox_element(:xpath => "./tbody[@class='yui-dt-data']/tr[#{num_index+1}]/td[#{@hash_patient_reminder_list_table[:TASK]}]/div/input").click
          sleep 3
          div_copy_right_element.scroll_into_view rescue Exception
          button_send_reminder_element.click
          wait_for_loading

          bool_patient_exists, num_index = is_patient_exists(str_patient_id)
          num_max -= 1
          break if num_max <= 0
        end
=end
        raise "Patient reminder is not configured yet" if is_text_present(self, "Patient reminder is not configured yet", 5)
        #raise "Error in sending patient reminder for patient #{str_patient_id}" if !is_text_present(self, "Patient reminder sent sucessfully")
        $log.success("Reminder mail sent to patient '#{str_patient_id}' successfully")
        return true
      rescue Exception => ex
        $log.error("Error while sending reminder for the patient (#{str_patient_id}) : #{ex}")
        exit
      end
    end

    # description            : generates report based on start date of the current year
    # Author                 : Chandra sekaran
    # Argument               :
    #   str_reporting_period : date string
    #
    def generate_report(str_reporting_period = pacific_time_calculation.strftime("0101%Y"))
      begin
        # select the reporting period date for which the patient details will be displayed
        wait_for_object(textfield_reporting_period_element, "Failure in finding Reporting period textbox in Send Patient Reminders page")
        self.textfield_reporting_period = str_reporting_period
        click_on(button_search_element)
        wait_for_object(table_patient_reminder_list_element, "Failure in finding Patient List table")
      rescue Exception => ex
        $log.error("Error while generating Send Patient Reminder report from #{str_reporting_period} : #{ex}")
        exit
      end
    end

    # description          : checks for the existance of patient with the given Patient ID
    # Author               : Chandra sekaran
    # Argument             :
    #   str_patient_id     : patient ID
    # Return argument      : a boolean value
    #
    def is_patient_exists(str_patient_id)
      begin
        @str_row = nil
        if table_patient_reminder_list_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_patient_reminder_list_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end

        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          return false #raise "No records found in Send Patient Reminder report table"
        else
          sleep 1 until !table_patient_reminder_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
        end

        div_copy_right_element.scroll_into_view rescue Exception
        # select the particular patient and send reminder
        click_last(div_patient_reminder_list_element)  # moves to the last page
        wait_for_loading
        wait_for_object(table_patient_reminder_list_element, "Failure in finding Patient List table")
        table_patient_reminder_list_element.table_elements(:xpath => $xpath_tbody_data_row).each_with_index do |row, index|
          row.scroll_into_view rescue Exception
          3.times { row.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"
          str_pat_id = row.cell_element(:xpath => "./td[#{@hash_patient_reminder_list_table[:PATIENT_ID]}]").when_visible.text
          if str_pat_id.strip == str_patient_id
            $log.success("Patient (#{str_patient_id}) record found in Send Patient Reminder report table")
            return true, index
          end
        end
        return false
      rescue Exception => ex
        $log.error("Error while searching for patient(#{str_patient_id}) in Send Patient Reminder page : #{ex}")
        exit
      end
    end

    # description          : sends reminder for all patients listed in the table
    # Author               : Chandra sekaran
    # Argument             :
    #
    def send_reminder_for_all_patients
      begin
        generate_report
        obj_select_all = table_patient_reminder_list_element.cell_element(:xpath => "./thead/tr/th[#{@hash_patient_reminder_list_table[:TASK]}]/div/input")

        if is_text_present(self, "Loading", 7)
          sleep 1 until !table_patient_reminder_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
        end

        num_max = 5  # for breaking the iteration
        while !is_text_present(self, "No records found", 7)
          obj_select_all = table_patient_reminder_list_element.checkbox_element(:xpath => "./thead/tr/th[#{@hash_patient_reminder_list_table[:TASK]}]/div/input")
          obj_select_all.click
          div_copy_right_element.scroll_into_view rescue Exception
          button_send_reminder_element.click
          wait_for_loading
          if is_text_present(self, "Loading", 7)
            sleep 1 until !table_patient_reminder_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
          end
          #sleep 5
          num_max -= 1
          break if num_max <= 0
        end
      rescue Exception => ex
        $log.error("Error while sending reminder for all patients under Send Patient Reminders table : #{ex}")
        exit
      end
    end

  end
end