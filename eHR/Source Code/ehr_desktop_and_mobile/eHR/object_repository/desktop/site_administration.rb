=begin
  *Name               : SiteAdministration
  *Description        : class that holds methods for handling Site Administration
  *Author             : Gomathi
  *Creation Date      : 02/24/2015
  *Modification Date  :
=end

module EHR
  class SiteAdministration
    include PageObject
    include PageUtils

    # Menu options under Site Administration
    link(:link_users_and_groups,                                         :id     =>  "tabGrp")

    # Organization details
    text_field(:textfield_organization_name,                             :id     =>  "OrganizationNametxt")
    text_field(:textfield_address1,                                      :id     =>  "Address1txt")
    text_field(:textfield_address2,                                      :id     =>  "Address2txt")
    text_field(:textfield_access_url_key,                                :id     =>  "AccessUrltxt")
    text_field(:textfield_city,                                          :id     =>  "Citytxt")
    select_list(:select_country,                                         :id     =>  "CountryIDddl")
    select_list(:select_state,                                           :id     =>  "StateIDddl")
    text_field(:textfield_zip,                                           :id     =>  "Ziptxt")
    text_field(:textfield_org_phone_no,                                  :id     =>  "Phonetxt")
    text_field(:textfield_org_fax,                                       :id     =>  "FAXtxt")
    text_field(:textfield_org_email,                                     :id     =>  "Emailtxt")
    text_field(:textfield_security_key,                                  :id     =>  "SecurityKeytxt")

    # Medical Records contact information details
    text_field(:textfield_records_phone,                                 :id     =>  "MedicalRecordsPhone")
    text_field(:textfield_records_email,                                 :id     =>  "MedicalRecordsEmail")
    text_field(:textfield_records_fax,                                   :id     =>  "MedicalRecordsFax")
    file_field(:filefield_logo,                                          :id     =>  "fileOrgLogo")
    file_field(:filefield_header,                                        :id     =>  "fileOrgHeader")
    file_field(:filefield_footer,                                        :id     =>  "fileOrgFooter")

    # Patient Report Information details
    text_field(:textfield_report_delay_days,                             :id     =>  "OrganizationReportDelayTxt")
    text_area(:textarea_report_text,                                     :id     =>  "ReportText")

    # Organization Level Application Setting details
    text_field(:textfield_session_timeout_limit,                         :id     =>  "SessionTimeouttxt")
    select_list(:select_height_measurement,                              :id     =>  "heightMesure")
    select_list(:select_weight_measurement,                              :id     =>  "weightMesure")
    select_list(:select_user_pin,                                        :id     =>  "PINTypeID")
    select_list(:select_drug_severity_level,                             :id     =>  "Severity")
    select_list(:select_time_zone,                                       :id     =>  "ddltimeZone")
    checkbox(:check_vital_not_require_for_compliance,                    :id     =>  "chkVitalnotRequiredForCompilence")
    checkbox(:check_reconciliation_not_require_for_compliance,           :id     =>  "chkMedReconclnnotRequiredForCompilence")

    # Meaningful Use Setting details
    checkbox(:check_all_visits_for_meaningful_use,                       :id     =>  "AutoVisitFaceToFace")
    text_field(:textfield_default_cpt_code,                              :id     =>  "CPTCode")
    button(:button_select_cpt_code,                                      :xpath  =>  "//div[@class='btn_cpt']/input")
    button(:button_clear_cpt_code,                                       :class  =>  "clear-button")

    # CPT/SNOMED Code Listing
    div(:div_cpt_code,                                                   :id     =>  "divcodedescList")
    div(:div_cpt_code_list,                                              :id     =>  "cntCPTSnomedCodeList")
    table(:table_cpt_code_list,                                          :xpath  =>  "//div[@id='cntCPTSnomedCodeList']/table")

    # Personal Health Record System (Health Companion) Settings details
    checkbox(:check_auto_reconcile,                                      :id     =>  "AutoReoncile")
    checkbox(:check_do_not_send_reg_mail,                                :id     =>  "DontSendRegistrationMail")
    checkbox(:check_send_eoe_to_phr_without_viewing,                     :id     =>  "chkSendPHRMailWithoutViewing")
    checkbox(:check_auto_send_eoe,                                       :id     =>  "chkEnableAutoEOE")
    text_field(:textfield_auto_eoe_wait_time,                            :id     =>  "AutoEOFWaitTime")

    span(:span_update_org_details,                                       :id     =>  "lnkUpdatedOrganizationDetails")
    button(:button_update_org_details,                                   :id     =>  "lnkUpdatedOrganizationDetails-button")

    # Description  : Function will get invoked when object for page class is created
    # Author       : Chandra sekaran
    #
    def initialize_page
      create_hash
    end

    # Description  : hash for grouping index of table headers in the name of constant keys
    # Author       : Chandra sekaran
    #
    def create_hash
      @hash_cpt_code_table = {
          :SELECT => 1,
          :CPT_CODE => 2,
          :DESCRIPTION => 3
      }
    end

    # Description     : function for updating status of auto face-to-face visit setup
    # Author          : Chandra sekaran
    # Argument        :
    #   str_status    : status if checked or unchecked
    #
    def update_auto_face_to_face_visit_status(str_status)
      begin
        div_copy_right_element.scroll_into_view rescue Exception
        if str_status.downcase.include? "unchecked"
          uncheck_check_all_visits_for_meaningful_use if check_all_visits_for_meaningful_use_element.checked?
        elsif str_status.downcase.include? "checked"
          check_check_all_visits_for_meaningful_use if !check_all_visits_for_meaningful_use_element.checked?
        else
          raise "Invalid action : #{str_status}"
        end
        button_update_org_details_element.click
        raise "Error in updating Auto Face to Face visit" if !is_text_present(self, "Organization details updated successfully", 3)
        $log.success("Successfully #{str_status} Auto Face to Face visit")
      rescue Exception => ex
        $log.error("Failure in updating status of Auto face to face visit (#{str_status}) : #{ex}")
        exit
      end
    end

    # Description     : function for updating default CPT code setup
    # Author          : Chandra sekaran
    # Argument        :
    #   str_action    : action to set or reset(clear)
    # Return argument :
    #   str_return    : return the currently set CPT value
    #
    def update_cpt_code(str_action)
      begin
        str_return = ""
        div_copy_right_element.scroll_into_view rescue Exception
        if str_action.downcase == "set"
          button_select_cpt_code_element.click
          wait_for_loading
          wait_for_object(div_cpt_code_element, "Could not find CPT code list div element")
          str_cptcode = table_cpt_code_list_element.cell_element(:xpath => "#{$xpath_tbody_data_first_row}/td[#{@hash_cpt_code_table[:CPT_CODE]}]").text.strip
          table_cpt_code_list_element.checkbox_element(:xpath => "#{$xpath_tbody_data_first_row}/td[#{@hash_cpt_code_table[:SELECT]}]/div/input").click
          tmp_cptcode = self.textfield_default_cpt_code
          raise "Could not select CPT code '#{str_cptcode}'" if str_cptcode != tmp_cptcode.strip
          button_update_org_details_element.click
          raise "Error while updating CPT code" if !is_text_present(self, "Organization details updated successfully", 3)
          $log.success("Successfully set default CPT code to '#{str_cptcode}'")
          str_return = str_cptcode
        elsif str_action.downcase == "cleared"
          button_clear_cpt_code_element.click
          str_placeholder_text = @browser.find_element(:id, "CPTCode").attribute("placeholder")     # get placeholder content
          raise "CPT code textfield is not cleared" if !(str_placeholder_text.downcase.include?("please select"))
          button_update_org_details_element.click
          raise "Error while updating CPT code" if !is_text_present(self, "Organization details updated successfully", 3)
          $log.success("Successfully cleared CPT code")
          str_return = str_placeholder_text
        end
        str_return
      rescue Exception => ex
        $log.error("Failure while updating CPT code(#{str_action} action) : #{ex}")
        exit
      end
    end

    # Description     : function for clearing default CPT code
    # Author          : Chandra sekaran
    #
    def clear_cpt_code
      begin
        div_copy_right_element.scroll_into_view rescue Exception
        button_clear_cpt_code_element.click
        str_placeholder_text = @browser.find_element(:id, "CPTCode").attribute("placeholder")     # get placeholder content
        raise "CPT code textfield is not cleared" if !(str_placeholder_text.downcase.include?("please select"))
        button_update_org_details_element.click
        raise "Error while updating CPT code" if !is_text_present(self, "Organization details updated successfully", 3)
        $log.success("Successfully cleared CPT code")
      rescue Exception => ex
        $log.error("Failure while clearing CPT code : #{ex}")
        exit
      end
    end
  end
end

