=begin
  *Name             : ResendPatientReminders
  *Description      : Class Objects for to resending the reminder mails to patients
  *Author           : Mani.Sundaram
  *Creation Date    : 19/03/2015
  *Modification Date:
=end

module EHR
  class ResendPatientReminders
    include PageObject
    include PageUtils
    include Pagination

    form(:form_resend_patient_reminder,                :id        => "frmPatientReminderSend")
    text_field(:textfield_patient_id,                   :id        => "PatientId")
    text_field(:textfield_patient_reminder_from_date,  :name      => "ReminderSendFromDate")
    text_field(:textfield_patient_reminder_to_date,    :name      => "RemiderSendToDate")
    button(:button_patient_send_reminder_search,       :id        => "lnkSearch-button")
    div(:div_patient_reminder_list,                    :id        => "cntPatientReminderList")
    table(:table_patient_reminder_list,                :xpath     => "//div[@id='cntPatientReminderList']/table")
    link(:link_resent_reminder,                        :link_text => "Resend Reminder")

    # description          : invoked automatically when page class object is created
    # Author               : Mani.Sundaram
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      wait_for_object(form_resend_patient_reminder_element, "Failure in finding patient reminder send form")
      create_hash
    end

    # description          : create hash for indexing resending patient reminder list table
    # Author               : Mani.Sundaram
    #
    def create_hash
      @hash_resent_patient_reminder_list_table = {
          :TASK => 1,
          :LAST_NAME => 2,
          :FIRST_NAME => 3,
          :PATIENT_ID => 4,
          :DATE_OF_BIRTH => 5,
          :PREFERRED_PHONE_NO => 6,
          :SEND_ON => 7,
          :STATUS => 8
      }
    end

    # description          : Resending the reminder to patient
    # Author               : Mani.Sundaram
    #
    def resend_reminder
      begin
        object_date_time = pacific_time_calculation
        str_from_date = object_date_time - 1.days

        textfield_patient_id_element.focus
        self.textfield_patient_id = $str_patient_id
        textfield_patient_reminder_from_date_element.focus
        self.textfield_patient_reminder_from_date = str_from_date.strftime(DATE_FORMAT)
        textfield_patient_reminder_to_date_element.focus
        self.textfield_patient_reminder_to_date = object_date_time.strftime(DATE_FORMAT)
        click_on(button_patient_send_reminder_search)

        wait_for_loading
        div_copy_right_element.when_visible.scroll_into_view rescue Exception
        wait_for_object(table_patient_reminder_list_element, "Failure in finding patient reminder list table")

        raise "No records found in Patient Reminder List" if is_text_present(self, "No records found", 5)

        bool_iterate = true
        while(bool_iterate)
          table_patient_reminder_list_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
            if row.cell_element(:xpath => "./td[#{@hash_non_compliance_table_header[:PATIENT_ID]}]").text.strip == $str_patient_id
              row.image_element(:src => "/Content/themes/base/images/menu.gif").fire_event("onmouseover")
              link_resent_reminder_element.click
              return true
            end
          end
          bool_iterate = click_next(div_patient_reminder_list_element)
          wait_for_loading
        end
        raise "Some Configuration error while sending reminder to patient" if is_text_present(self, "Patient reminder not sent. Reminder text not configured yet or communication issue.", 5)
      rescue Exception => ex
        $log.error("Error while generating patient reminder:#{ex} ")
        exit
      end
    end
  end
end