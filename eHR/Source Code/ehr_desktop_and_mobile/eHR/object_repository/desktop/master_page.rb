=begin
  *Name               : MasterPage
  *Description        : contains all objects and methods in Application Master Page
  *Author             : Gomathi
  *Creation Date      : 19/08/2014
  *Modification Date  :
=end

module EHR
  class MasterPage

    include PageObject
    include Win32
    include PageUtils

    div(:div_login_container,                    :id        => "login_container")   # container for login

    div(:div_logo,                               :class     => "logo")
    div(:div_testing_org,                        :class     => "message")

    # List of links available under sub menu
    link(:link_demographics,                     :id        => "lnkDemographics")
    link(:link_health_status,                    :id        => "lnkHealthStatus")
    link(:link_visit_notes,                      :id        => "lnkVisitDocument")
    link(:link_order_entry_result,               :id        => "lnkOrderEntryResult")
    link(:link_inbox,                            :id        => "lnkInbox")
    link(:link_select_patient,                   :id        => "dvstpatient")

    # List of links available under main menu
    link(:link_home,                             :link_text => "Home")
    link(:link_tasks,                            :link_text => "Tasks")
    link(:link_compliance,                       :link_text => "Compliance")
    link(:link_setup,                            :link_text => "Set Up")

    # List of sub menu available under Tasks menu
    link(:link_patient_request_health_info,      :link_text => "Patient Requests Health Information")
    link(:link_create_electronic_summary,        :link_text => "Create Electronic Summary")
    link(:link_generate_patient_list,            :link_text => "Generate Patient List")
    link(:link_generate_reminder_list,           :link_text => "Generate Reminder List")
    link(:link_send_patient_reminders,           :link_text => "Send Patient Reminders")
    link(:link_resend_patient_reminders,         :link_text => "Resend Patient Reminders")
    link(:link_generate_CQM_reports,             :link_text => "Generate CQM Reports")

    # List of sub menu available under Create Electronic Summary menu
    link(:link_generate_transition_of_care_doc,  :link_text => "Generate Transition of Care document")
    link(:link_generate_export_summary,          :link_text => "Generate Export Summary")

    # List of sub menu available under Compliance menu
    link(:link_non_compliance_report,            :link_text => "Non-Compliance Report")
    link(:link_automated_measure_calculator,     :link_text => "Automated Measure Calculator")
    link(:link_measurement_attestations,         :link_text => "Measurement Attestations")

    # List of sub menu available under Set Up menu
    link(:link_site_administration,              :link_text => "Site Administration")
    link(:link_eligible_professional,            :link_text => "Eligible Professional")
    link(:link_end_of_exam_visit_template,       :link_text => "End Of Exam/Visit Template")
    link(:link_patient_educational_material,     :link_text => "Patient Educational Material")
    link(:link_decision_support_rules,           :link_text => "Decision Support Rules")
    link(:link_Patient_reminder_text,            :link_text => "Patient Reminder Text")
    link(:link_safety_checker,                   :link_text => "Safety Checker")
    link(:link_communications,                   :link_text => "Communications")
    link(:link_other_data_administration,        :link_text => "Other Data Administration")

    # List of sub menu available under Safety Checker menu
    link(:link_gadolinium,                       :link_text => "Gadolinium")
    link(:link_iodine,                           :link_text => "Iodine")

    # List of sub menu available under Communications menu
    link(:link_e_prescriptions,                  :link_text => "e-Prescriptions")
    link(:link_submit_patient_clinical_documents,:link_text => "Submit Patient Clinical Documents")
    link(:link_select_lab_result,                :link_text => "Select Lab Result")
    link(:link_received_clinical_documents,      :link_text => "Received Clinical Documents")
    link(:link_submit_patient_amendments,        :link_text => "Submit Patient Amendments")

    # List of sub menu available under Other Data Administration menu
    link(:link_clinic,                           :link_text => "Clinic")
    link(:link_lab,                              :link_text => "Lab")
    link(:link_site,                             :link_text => "Site")
    link(:link_facility,                         :link_text => "Facility")
    link(:link_drug_formulary,                   :link_text => "Drug Formulary")
    link(:link_drug_interaction,                 :link_text => "Drug Interaction")
    link(:link_CQM_report_2012_2013,             :link_text => "CQM Report (2012 - 2013)")

    # Objects of text visible below menu
    # not required; used xpath instead
    # label(:label_welcome, :id => "lblLoggedinuser")   # by using this label ID, traverse to its parent and find text of first span will give username
    span(:span_username,                        :xpath     => "//div[@id='welcomeinfo']/div[@class='welcome']/p/span[1]")
    link(:link_profile,                         :link_text => "Profile")
    link(:link_logout,                          :link_text => "Logout")
    div(:div_selected_info,                     :id        => "selectedinfo")   # div that provides information about selected patient and Visit created for that patient
    label(:label_selected_patient_name,         :id        => "lblSelPatientName")
    label(:label_patient_id,                    :xpath     => "//div[@id='selectedinfo']/p[1]/label[2]")
    label(:label_patient_DOB,                   :xpath     => "//div[@id='selectedinfo']/p[1]/label[3]")
    label(:label_modality,                      :xpath     => "//div[@id='selectedinfo']/p[2]/label[1]")
    label(:label_exam,                          :xpath     => "//div[@id='selectedinfo']/p[2]/label[2]")
    label(:label_exam_date,                     :xpath     => "//div[@id='selectedinfo']/p[3]/label[1]")
    label(:label_eligible_professional,         :xpath     => "//div[@id='selectedinfo']/p[3]/label[2]")

    # Objects appear sometimes in the webpage
    div(:div_conform_dialog,                    :id        => "conformdialog")      # dialog box for Your session is about to time out. Click OK to keep session
    button(:button_conform_ok,                  :id        => "yui-gen42-button")    # ok button for conform dialog box
    div(:div_change_password, 					:id        => "changepassword")

    ## Objects of items visible at bottom of page
    #div(:div_copy_right,                        :id        => "footer")
    #div(:div_toolbar,                           :id        => "toolbar")

    # MU checklist ribbons contents
    link(:link_demographics_ribbon,             :xpath     => "//ul[@id='social']/li[1]/a")
    link(:link_problems_ribbon,                 :xpath     => "//ul[@id='social']/li[2]/a")
    link(:link_allergies_ribbon,                :xpath     => "//ul[@id='social']/li[3]/a")
    link(:link_medications_ribbon,              :xpath     => "//ul[@id='social']/li[4]/a")
    link(:link_reconciliation_ribbon,           :xpath     => "//ul[@id='social']/li[5]/a")
    link(:link_family_history_ribbon,           :xpath     => "//ul[@id='social']/li[6]/a")
    link(:link_vitals_ribbon,                   :xpath     => "//ul[@id='social']/li[7]/a")
    link(:link_smoking_status_ribbon,           :xpath     => "//ul[@id='social']/li[8]/a")
    link(:link_end_of_exam_ribbon,              :xpath     => "//ul[@id='social']/li[9]/a")
    list_item(:li_end_of_exam_ribbon,           :xpath     => "//ul[@id='social']/li[9]")

    # Send reminder button contents
	  body(:body_pdf_window,                      :xpath     => "html/body")
    div(:div_continue_popup,                    :xpath     => "//div[@id='popup_small']/div[2]")
    button(:button_continue_popup_ok,           :id        => "felixInformartiondgl-button")
    div(:div_send_email_popup,                  :id        => "popup_small")
    button(:button_send_email_popup_yes,        :id        => "lnkInteractionMsg-button")
    button(:button_send_email_popup_no,         :id        => "lnkCloseInteractionMsg-button")
    div(:div_resend_email_popup,                :id        => "conformdialog_c")
    button(:button_resend_email,                :text      => "Resend")
    button(:button_cancel_resend,               :text      => "Cancel")

    # Order Entry/Results sub tab menu headers
    link(:link_lab,                             :link_text  => "Lab")
    link(:link_radiology,                       :link_text  => "Radiology")
    link(:link_medications,                     :link_text  => "Medications")
    link(:link_reports,                         :link_text  => "Reports")

    # description          : function for selecting menu
    # Author               : Gomathi
    # Arguments            :
    #   str_menu_item_path : string for menu item traversing path
    #
    def select_menu_item(str_menu_item_path)
      begin
        wait_for_loading
        div_logo_element.when_visible.scroll_into_view rescue Exception
        div_logo_element.focus
        if str_menu_item_path == "Set Up/End Of Exam/Visit Template"
          arr_menu = ["Set Up", "End Of Exam/Visit Template"]
        else
          arr_menu = str_menu_item_path.split('/')
        end
        str_click_link_text = arr_menu.pop
        select_menu_process(arr_menu, str_click_link_text)

        # if the menu/sub menu item is not selected
        bool_condition = is_menu_item_selected(str_click_link_text)
        select_menu_process(arr_menu, str_click_link_text) if !bool_condition

      rescue Exception => ex
        $log.error("Error while hovering menu item (#{str_menu_item_path}) : #{ex}")
        exit
      end
    end

    # description           : function for verifying whether the menu is selected or not
    # Author                : Gomathi
    # Arguments             :
    #   str_click_link_text : string denotes link text for click
    # Return argument       : returns true if menu selected or else returns false
    #
    def is_menu_item_selected(str_click_link_text)
      case str_click_link_text
        when "Automated Measure Calculator"
          bool_condition = is_text_present(self, "Automated Measure Calculation", 30)
        when "Generate Transition of Care document"
          wait_for_loading
          bool_condition = is_text_present(self, "Transition of Care Document", 10) || is_text_present(self, "Please select", 10)
        when "Submit Patient Clinical Documents"
          wait_for_loading
          bool_condition = is_text_present(self, "Upload Summary", 10)
        when "Received Clinical Documents"
          current_page_url = self.current_url
          bool_condition = current_page_url.include?("PatientDocument")
        when "Eligible Professional", "Physician Setup"
          current_page_url = self.current_url
          bool_condition = current_page_url.include?("Physicians")
        when "Generate Patient List"
          bool_condition = is_text_present(self, "This list is being created for Eligible Professional", 20)
          #current_page_url = self.current_url
          #bool_condition = current_page_url.include?("GeneratePatientList")
        when "Send Patient Reminders"
          bool_condition = self.current_url.include?("LoadPatientReminderSearch")
        when "Home"
          bool_condition = is_text_present(self, "Search Patient", 30)
        when "Non-Compliance Report"
          bool_condition = is_text_present(self, "Non-Compliance Report", 30)
        when "Site Administration"
          bool_condition = is_text_present(self, "Users and Groups", 20)
        when "Site"
          bool_condition = is_text_present(self, "Create Site", 20)
        when "Generate Export Summary"
          bool_condition = is_text_present(self, "The zip file downloaded would have the Clinical Summary of all the active patients of the organization." , 30)
        when "Patient Requests Health Information"
          bool_condition = is_text_present(self, "Are you creating this report at the patient request?", 20)
        when "Generate CQM Reports"
          bool_condition = is_text_present(self, "Category 1 Report", 20)
        when "Generate Reminder List"
          bool_condition = is_text_present(self, "Generate Patient Reminder List", 20)
      end
      return bool_condition
    end

    # description           : function to hover the main menu and select sub menu
    # Author                : Gomathi
    # Arguments             :
    #   arr_menu            : array denotes link texts to hover and click
    #   str_click_link_text : string denotes link text for click
    #
    def select_menu_process(arr_menu, str_click_link_text)
      arr_menu.each do |str_link_text|
        wait_for_object(link_element(:link_text => str_link_text), "Failure in finding link for menu #{str_link_text}")
        link_element(:link_text => str_link_text).fire_event("onmouseover")
        sleep 1
      end
      if BROWSER.downcase == "chrome"
        if str_click_link_text == "Eligible Professional"
          begin
            link_element(:link_text => str_click_link_text).click
          rescue Exception => ex
            link_element(:link_text => "Physician Setup").click
          end
        elsif str_click_link_text == "Physician Setup"
          begin
            link_element(:link_text => str_click_link_text).click
          rescue Exception => ex
            link_element(:link_text => "Eligible Professional").click
          end
        else
          link_element(:link_text => str_click_link_text).click
        end
      elsif BROWSER.downcase == "ie" || BROWSER.downcase == "internet_explorer"
        ie_handler(str_click_link_text)
      end
      wait_for_page_load
      wait_for_loading
    end

    # description           : function for menu selection in IE
    # Author                : Gomathi
    # Arguments             :
    #   str_click_link_text : string denotes link text for click
    #
    def ie_handler(str_click_link_text)
      if str_click_link_text.include? "Generate Transition of Care document"
        self.execute_script("fnGenerateHealthRecordCDA();")    # javascript method for opening Generate TOC iframe
        link_element(:link_text => "Tasks").click
      elsif str_click_link_text.include?("Automated Measure Calculator")
        self.execute_script("MeasureCalculationList();")    # javascript method for opening AMC report page
        #link_element(:link_text => "Compliance").click
      elsif str_click_link_text == "Site"
        #link_element(:xpath => "//a[contains(@href, '../Sites')]").click
        #@browser.find_element(:link, "Site").click
        url = ""
        if @browser.current_url.include? "Physicians"
          url = @browser.current_url.split("Physicians").first + "Sites"
        elsif @browser.current_url.include? "Demographics"
          url = @browser.current_url.split("Demographics").first + "Sites"
        end
        #$log.info("----------site url - #{url}")
        @browser.navigate.to(url)
      elsif str_click_link_text == "Eligible Professional"
          begin
            link_element(:link_text => str_click_link_text).click
          rescue Exception => ex
            link_element(:link_text => "Physician Setup").click
          end
      elsif str_click_link_text == "Physician Setup"
          begin
            link_element(:link_text => str_click_link_text).click
          rescue Exception => ex
            link_element(:link_text => "Eligible Professional").click
          end
      else
        link_element(:link_text => str_click_link_text).click
        begin
          if link_element(:link_text => str_click_link_text).visible?
            $log.error("Link '#{str_click_link_text}' is not clicked and is still visible")
            link_element(:link_text => str_click_link_text).fire_event("click")
          end
        rescue Exception => ex
          $log.error("Error in clicking link #{str_click_link_text} : #{ex}")
        end
      end
    end

    # description          : logs out the current user
    # Author               : Chandra sekaran
    #
    def logout
      begin
        str_username = span_username.gsub('|','')
        wait_for_object(link_logout_element, "Failure in finding 'Logout' link", 30)
        click_on(link_logout_element)
        wait_for_page_load
        if link_logout_element.exists?
          #wait_for_loading
          click_on(link_logout_element)
          wait_for_page_load
        end
        wait_for_object(div_login_container_element, "Error in logging out", 60)

        $log.success("#{str_username.strip} logged out successfully from desktop web")
      rescue Exception => ex
        if (ex.message.downcase.include? "element is not clickable at point") || (ex.message.downcase.include? "failure in finding 'logout' link")
          self.execute_script("logout();")    # Javascript method to perform logout action
        else
          $log.error("Error while logging out(#{str_username}) from desktop web : #{ex}")
          exit
        end
      end
    end

    # description          : verifies the logged in user
    # Author               : Chandra sekaran
    #
    def verify_login
      begin
        ##wait_for_loading
        #current_page_url = self.current_url
        #if current_page_url.include?("ChangePassword")
         # raise "The password for '#{$username}' has been expired and need to be changed"
        #end
        if is_text_present(self, $username, 20)
          $log.success("#{$username} logged in successfully")
        else
          raise "#{$username} not logged in"
        end
      rescue Exception => ex
        $log.error("Error while verifying logged user(#{$username}) : #{ex}")
        exit
      end
    end

    # description          : checks if the user session is active (based on user name)
    # Author               : Chandra sekaran
    # return argument      : returns true if user is logged in else returns false
    #
    def is_session_active
      begin
        ##wait_for_loading
        if is_text_present(self, "Welcome", 5)
          if is_text_present(self, "Welcome#{$username}", 1)
            $log.success("#{$username} session is active")
            return true
          else
            logout
            return false
          end
        else
          return false
        end
      rescue Exception => ex
        return false
      end
    end

    # description       : opens the clinical summary report and checks for Patient Specific Education Material details
    # Author            : Chandra sekaran
    #
    def verify_clinical_summary
      begin
        wait_for_loading
        link_end_of_exam_ribbon_element.click
        wait_for_loading

        if div_continue_popup_element.exists? && button_continue_popup_ok_element.exists?
          button_continue_popup_ok_element.click
          sleep 1
        end
        if div_continue_popup_element.exists? && button_send_email_popup_yes_element.exists?
          button_send_email_popup_yes_element.click
          sleep 1
        end

        #if div_continue_popup_element.exists? && button_continue_popup_yes_element.exists?
        #  button_continue_popup_yes_element.focus
        #  button_continue_popup_yes_element.click
        #  sleep 1
        #end
        #
        #if div_send_email_popup_element.exists?
        #  button_send_email_popup_yes_element.click
        #  sleep 1
        #end

        # below script is for the updated EOE action
        # the downloaded clinical summary file is renamed with its test case ID and saved as pdf file under current_report/temp directory

        while !(File.exists?("#{File.expand_path($current_log_dir)}/GetEndOfVisit"))
          sleep 1
          $log.info("Waiting for the file to get download (Clinical document file)")
        end
        rename_file_type("#{File.expand_path($current_log_dir)}/GetEndOfVisit", "pdf")
        case_id = ""
        $scenario_tags.each do |tag|
          case_id = tag.split("_").last if tag.include?("@tc")
        end
        File.rename("#{File.expand_path($current_log_dir)}/GetEndOfVisit.pdf", "#{File.expand_path($current_log_dir)}/GetEndOfVisit_#{case_id}.pdf")
        str_pdf_content = ""
        reader = PDF::Reader.new("#{File.expand_path($current_log_dir)}/GetEndOfVisit_#{case_id}.pdf")
        reader.pages.each do |page|
          str_pdf_content << page.text
        end
        create_directory("#{File.expand_path($current_log_dir)}/temp")
        FileUtils.mv("#{File.expand_path($current_log_dir)}/GetEndOfVisit_#{case_id}.pdf", "#{File.expand_path($current_log_dir)}/temp")

        # commented as the Clinical document is downloaded instead of opening in a new pdf window
        #if @browser.window_handles.size != 2    # EOE is not clicked properly
        #  link_end_of_exam_ribbon_element.click
        #  wait_for_loading
        #
        #  if div_continue_popup_element.exists? && button_continue_popup_ok_element.exists?
        #    button_continue_popup_ok_element.click #if button_continue_popup_ok_element.exists?
        #    sleep 1
        #  end
        #
        #  if div_continue_popup_element.exists? && button_continue_popup_yes_element.exists?
        #    button_continue_popup_yes_element.focus
        #    button_continue_popup_yes_element.click
        #    sleep 1
        #  end
        #
        #  if div_send_email_popup_element.exists?
        #    button_send_email_popup_yes_element.click
        #    sleep 1
        #  end
        #end

        #switch_to_next_window    # switches to the pdf window

        # as of now the script works with chrome only
        #if BROWSER.downcase == "chrome"
        #  Clipboard.clear       # clear clipboard
        #  body_pdf_window_element.when_visible.send_keys([:control, 'a'], [:control, 'c'])   # copy pdf content to clipboard
        #  str_pdf_content = Clipboard.data

          #raise("The patient id #{$str_patient_id} does not exists in Clinical report") if !str_pdf_content.include? $str_patient_id
          #raise("The EP name #{$str_ep_name} does not exists in Clinical report") if !str_pdf_content.include? $str_ep_name
          $log.success("The patient id (#{$str_patient_id}) and EP name (#{$str_ep_name}) exists in Clinical summary report ")

          num_count = 0

          if !$arr_problem_list_name.nil? && !$arr_problem_list_name.empty?
            for index in 0..$arr_problem_list_name.size-1
              num_count += 1 if str_pdf_content.include? $arr_problem_list_name[index]
            end
            $log.success("Problem #{$arr_problem_list_name} found in Clinical summary")  if num_count == $arr_problem_list_name.size
          end

          num_count = 0
          if !$arr_medication_list_name.nil? && !$arr_medication_list_name.empty?
            for index in 0..$arr_medication_list_name.size-1
              num_count += 1 if str_pdf_content.include? $arr_medication_list_name[index]
            end
            $log.success("Medication #{$arr_medication_list_name} found in Clinical summary")  if num_count == $arr_medication_list_name.size
          end
        #end

        # close the pdf window and switch to application window
        close_application_windows
        $num_s2_provide_clinical_summary += 1 if $arr_valid_exam_id.size != 0
        $num_s2_patient_electronic_access +=1 if $arr_all_exam_id.size != 0
        $num_s1_provide_clinical_summary += 1 if $arr_valid_exam_id.size != 0
        $num_transition_summary_of_care += 1 if $arr_valid_exam_id.size != 0
        $num_s1_patient_electronic_access += 1 if $arr_all_exam_id.size != 0
      rescue Exception => ex
        $log.error("Error while checking for clinical summary report : #{ex}")
        exit
      end
    end

    def select_tab(str_tab)
      begin
        case str_tab.downcase
          when "health status"
            select_menu_item(HOME)
            click_on(link_health_status_element)
            if !is_text_present(self, "Problem List Coded Items")
              wait_for_loading
              link_health_status_element.click
              wait_for_loading
            end

          when "order entry", "order entry/results"
            select_menu_item(HOME)
            sleep 3 if BROWSER.downcase == "chrome"  # static delay for sync issue
            wait_for_loading
            begin
              link_order_entry_result_element.when_visible.click   # clicks 'Order Entry/Results' tab
            rescue Exception => e
              wait_for_loading
              link_order_entry_result_element.when_visible.click
            end
            wait_for_loading
            click_on(link_order_entry_result_element) if !is_text_present(self, "Specimen Source", 30)

          when "medication order"
            click_on(link_medications_element)
            click_on(link_medications_element) if !is_text_present(self, "Pharmacy")

          when "radiology order"
            click_on(link_radiology_element)  # clicks 'Radiology' tab under 'Order Entry/Results' tab)
            click_on(link_radiology_element) if !is_text_present(self, "Site")

          when "laboratory order"
            click_on(link_lab_element)     # clicks 'Laboratory' tab under 'Order Entry/Results' tab
            click_on(link_order_entry_result_element) if !is_text_present(self, "Specimen Source")

          when "visit notes"
            link_visit_notes_element.when_visible.click
            wait_for_loading
            if !is_text_present(self, "Visit Note Type")
              link_visit_notes_element.click
              wait_for_loading
            end

          when "demographics"
            select_menu_item(HOME)
            wait_for_loading
            link_demographics_element.when_visible.click
            if !is_text_present(self, "Contact Information", 10)
              link_demographics_element.click
              wait_for_loading
            end

          #else
          #  raise "Invalid tab name : #{str_tab}"       # not required as it needs to be skipped
        end
      rescue Exception => ex
        $log.error("Error while selecting tab (#{str_tab}) : #{ex}")
        exit
      end
    end

  end
end