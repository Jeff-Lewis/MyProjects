=begin
  *Name             : DashboardPage
  *Description      : class that holds the dashboard page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class DashboardPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    div(:div_login_container,                             :id      => "login_container")

    #div(:div_home,                                        :id      => "pageHome")
    select_list(:select_ep,                               :id       => "cmbPhysician")
    link(:link_new_patient,                               :id      => "btnNewPatient")
    link(:link_search_patient,                            :id      => "btnSearch")

    # Recently added patients
    div(:div_patient_list,                                :id      => "divPatientList")
    unordered_list(:ul_patient_list,                      :id      => "lstPatientView")

    # Search patient
    div(:div_search_patient,                              :id      => "pnlSearchPatient")
    div(:div_search_patient_panel,                        :class   => "ui-panel-inner")
    text_field(:textfield_last_name,                      :id      => "txtlastName")
    text_field(:textfield_first_name,                     :id      => "txtFirstName")
    text_field(:textfield_patient_id,                     :id      => "txtPatId")
    text_field(:textfield_dob,                            :id      => "txtDateofBrithsrch")
    link(:link_search,                                    :id      => "btndoSearch")
    #span(:link_search,                                    :xpath   => "//a[@id='btndoSearch']/span")

    #link(:link_logout,                                    :href    => "/Home/Logout")
    h4(:h4_user_name,                                     :xpath   => "//div[@id='pageHome']/h4")

    # Complete patient details - page tha appears when a specific patient is selected
    list_item(:listitem_patient_info,                     :id       => "liPersonalInfo")
    list_item(:listitem_demographics,                     :id       => "liDemographics")
    list_item(:listitem_communication,                    :id       => "liCommunications")
    list_item(:listitem_exam_info,                        :id       => "liVisitInfo")
    list_item(:listitem_clinical_data,                    :id       => "liClinicalDatas")

    # Description          : function for searching for patient(s) with the given input filter
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_filter         : filter name
    #   str_filter_value   : filter value
    #
    def search_patient(str_filter, str_filter_value)
      begin
        touch(button_home_element) if !link_new_patient_element.exists?  # go to dashboard page
        #return false if is_text_present(self, "No records found", 5)    # !required as it should get value from desktop web DB
        if str_filter.downcase != "random"    # unless the filter type is random
          touch(link_search_patient_element)
          wait_for_object(textfield_last_name_element, "Failure in finding Last Name field")
          case str_filter.downcase
            when "last name"
              self.textfield_last_name = str_filter_value
            when "first name"
              self.textfield_first_name = str_filter_value
            when "patient id", "id"
              str_filter_value = $str_patient_id if str_filter_value.nil? || str_filter_value.empty?
              self.textfield_patient_id = str_filter_value
            when "dob", "date of birth"
              self.textfield_dob = str_filter_value
            else
              raise "Invalid filter : #{str_filter}"
          end
          link_search_element.scroll_into_view rescue Exception
          link_logout_element.scroll_into_view rescue Exception
          link_logout_element.focus
          sleep 1
          touch(link_search_element)
          wait_for_object(div_patient_list_element, "Failure in finding Search result div element")
          raise "No patient record found for #{str_filter} #{str_filter_value}" if is_text_present(self, "No records found", 5)
        end

        tmp_id = ul_patient_list_element.div_element(:xpath => "./li[2]/div").text
        $str_patient_id = tmp_id.split("Patient ID:").last.split(",").first.strip

        touch(ul_patient_list_element.div_element(:xpath => "./li[2]/div"))   # select the first row record
        $log.success("Patient record with #{str_filter} '#{str_filter_value}' (#{$str_patient_id}) found")
      rescue Exception => ex
        $log.error("Failure in searching for patient with #{str_filter} #{str_filter_value} : #{ex}")
        exit
      end
    end

    # Description          : logs out the current user (mobile web)
    # Author               : Chandra sekaran
    #
    def logout
      begin
        touch(link_logout_element)
        #wait_for_object(div_login_container_element, "Time out in finding login page container element", 150)
        $log.success("#{$username} logged out successfully from mobile web")
      rescue Exception => ex
        $log.error("Error while logging out #{$username} from mobile web: #{ex}")
        exit
      end
    end

    # Description          : checks if the user session is active (based on user name)
    # Author               : Chandra sekaran
    # Return argument      : returns true if user is logged in else returns false
    #
    def is_session_active
      begin
        if is_text_present(self, "Welcome", 5)
          if is_text_present(self, "Welcome #{$username}", 1)
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

    # Description          : function for clicking the tab (navigation)
    # Author               : Chandra sekaran
    # Argument             :
    #   str_tab            : tab or section name
    #
    def touch_tab(str_tab)
      begin
        search_patient("patient ID", $str_patient_id) if @browser.current_url.include? "GetHome"
        case str_tab.downcase
          when "med allergy"
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
            if !(@browser.current_url.include?("GetClinicalDataAllergy"))
              click_next   # skip problems
              click_next   # skip medications
            end
          when /family history/
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
            if !(@browser.current_url.include?("GetClinicalDataFamilyHistory"))
              click_next   # skip problems
              click_next   # skip medications
              click_next   # skip med allergies
              click_next   # skip somking status
            end
          when "medication"
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
            if !(@browser.current_url.include?("GetClinicalDataMedication"))
              click_next   # skip problems
            end
          when /demographics/
            touch(listitem_demographics_element) if @browser.current_url.include? "GetPatientDetails"
          when /exam/, /visit/
            touch(listitem_exam_info_element) if @browser.current_url.include? "GetPatientDetails"
          when /problem/
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
          when "smoking status"
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
            if !(@browser.current_url.include?("GetClinicalDataSmokingStatus"))
              click_next   # skip problems
              click_next   # skip medications
              click_next   # skip med allergies
            end
          when "vitals"
            touch(listitem_clinical_data_element) if @browser.current_url.include? "GetPatientDetails"
            if !(@browser.current_url.include?("GetClinicalDataSmokingStatus"))
              click_next   # skip problems
              click_next   # skip medications
              click_next   # skip med allergies
              click_next   # skip somking status
              click_next   # skip family history
            end
          when "exam information"
            touch(listitem_exam_info_element) if @browser.current_url.include? "GetPatientDetails"
        end
      rescue Exception => ex
        $log.error("Error while clicking tab #{str_tab} : #{ex}")
        exit
      end
    end

    # Description          : function for navigating to the dashboard page
    # Author               : Chandra sekaran
    #
    def goto_home
      #touch(button_home_element) rescue Exception #if button_home_element.visible?
      begin
        touch(button_home_element) if !is_text_present(self, "Welcome", 2) #if !select_ep_element.visible?
      rescue Exception => ex
        $log.error("Error while navigating to Home page : #{ex}")
      end
    end

  end
end