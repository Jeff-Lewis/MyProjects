=begin
  *Name               : Communications
  *Description        : class that holds objects and methods related to Communications
  *Author             : Gomathi
  *Creation Date      : 03/23/2015
  *Modification Date  :
=end

module EHR
  class Communications
    include PageObject
    include PageUtils
    include Pagination
    include PatientDocument::DocumentNote
    include TransitionOfCare

    # Objects visible under upload CCD iframe
    form(:form_upload_ccd, :id => "frmSubmitCCD")
    file_field(:filefield_upload_ccd,             :id        => "uploadFileCCD")
    button(:button_upload_ccd,                    :id        => "lnkuploadCCD-button")
    button(:button_close_upload_form,             :id        => "lnkCloseUploadCCDDialog-button")

    # Objects visible under received CCD document window
    div(:div_clinical_document_lists,             :id        => "patient_doc_container_div")
    table(:table_clinical_document_lists,         :xpath     => "//div[@id='patient_doc_container_div']/table")
    link(:link_view_clinical_document,            :link_text => "View")
    link(:link_delete_clinical_document,          :link_text => "Delete")
    table(:table_patient_details_in_received_ccd, :xpath     => "//div[@id='ccdnew_style']/div/table[1]")
    table(:table_visit_details_in_received_ccd,   :xpath     => "//div[@id='ccdnew_style']/div/table[4]")

    div(:div_received_ccd_content,                :id        => "ccdnew_style")
    div(:div_search_patient_content,              :xpath     => "//div[@id='main_outer1']/div[@class='content_container']")
    text_field(:textfield_patient_last_name,      :id        => "LastNameSearch")
    text_field(:textfield_patient_first_name,     :id        => "FirstNameSearch")
    text_field(:textfield_patient_id,             :id        => "PatientIdSearch")
    text_field(:textfield_patient_dob,            :id        => "felix-widget-calendar-DateOfBirthSearch-input")
    button(:button_patient_search,                :id        => "lnkSearch-button")
    button(:button_patient_search_clear,          :id        => "ActionButton2-button")
    div(:div_patient_list,                        :id        => "patient_details_div")
    table(:table_patient_list,                    :xpath     => "//div[@id='patient_details_div']/table")
    label(:label_view_details,                    :link_text => "View Details")

    # objects under patient information iframe
    div(:div_patient_information,                 :id        => "create_patient")
    button(:button_attach,                        :id        => "ActionButton1-button")

    # description          : invoked automatically when page class object is created
    # Author               : Gomathi
    #
    def initialize_page
      wait_for_page_load
      create_hash
    end

    # description          : create hash for Clinical Documents table attributes
    # Author               : Gomathi
    #
    def create_hash
      @hash_clinical_documents_table = {
          :TASK => 1,
          :PATIENT_NAME => 2,
          :DATE_OF_BIRTH => 3,
          :RECEIVED_DATE => 4,
          :SENDING_SYSTEM => 5,
          :LAST_VIEWED_DATE => 6
      }
    end

    # Description        : uploads the ccd document
    # Author             : Gomathi
    #
    def upload_ccd_document
      begin
        wait_for_object(form_upload_ccd_element, "Failure in finding upload ccd form")

        hash_toc_yml = set_scenario_based_datafile(MEDICATION_RECONCILIATION)
        str_toc_file_name = hash_toc_yml["medication_reconciliation_data"]["toc_file_name"]

        str_feature_file_path = format_file_path($str_feature_file_path)
        if str_feature_file_path.include?("eHR")   # This is for running the script in Ruby Mine IDE
          arr_temp_path = str_feature_file_path.split("/")
          arr_temp_path.pop
          arr_temp_path.pop
          arr_temp_path.push("test_data")
          arr_temp_path.push(str_toc_file_name)
          str_toc_file_path = arr_temp_path * "/"
        else                                            # This is for running the script from command prompt
          str_toc_ruby_file_path = File.expand_path(File.dirname(__FILE__))
          arr_toc_ruby_file_path = str_toc_ruby_file_path.split("/")
          arr_toc_ruby_file_path.pop   # remove desktop directory
          arr_toc_ruby_file_path.pop   # remove object_repository directory
          str_parent_file_path = arr_toc_ruby_file_path * "/"
          str_absolute_feature_file_path = "#{str_parent_file_path}/#{str_feature_file_path}"
          arr_temp_path = str_absolute_feature_file_path.split("/")
          arr_temp_path.pop   # remove feature file name
          arr_temp_path.pop   # remove feature file directory
          arr_temp_path.push("test_data")
          arr_temp_path.push(str_toc_file_name)
          str_toc_file_path = arr_temp_path * "/"
        end

        if File.exists?(str_toc_file_path)
          self.filefield_upload_ccd = str_toc_file_path
        else
          raise "No such a file exist with file name (#{str_toc_file_name})"
        end
        click_on(button_upload_ccd_element)
        raise "CCD is not uploaded successfully" if !is_text_present(self, "Summary uploaded successfully")
        click_on(button_close_upload_form_element)
        $log.success("CCD uploaded successfully")
      rescue Exception => ex
        $log.error("Error while uploading Continuity of Care document : #{ex}")
        exit
      end
    end

    # Description        : selects a Patient record from received CCD based on Patient ID
    # Author             : Gomathi
    # Arguments          :
    #   str_patient_id   : Patient ID
    #
    def select_patient_from_ccd(str_patient_id)
      begin
        ##wait_for_loading
        wait_for_object(div_clinical_document_lists_element, "Failure in finding div for Clinical documents")
        table_clinical_document_lists_element.when_visible.scroll_into_view rescue Exception
        div_copy_right_element.scroll_into_view rescue Exception
        #3.times { table_clinical_document_lists_element.send_keys(:arrow_down)} rescue Exception if BROWSER.downcase == "chrome"
        click_last(div_clinical_document_lists_element)
        size = table_clinical_document_lists_element.table_elements(:xpath => "./tbody[@class='yui-dt-data']/tr").size

        obj_task = table_clinical_document_lists_element.table_element(:xpath => "./tbody[@class='yui-dt-data']/tr[#{size}]").image_element(:xpath => "./td[#{@hash_clinical_documents_table[:TASK]}]/div/img")
        obj_task.focus
        obj_task.fire_event("onmouseover")
        wait_for_object(link_view_clinical_document_element, "Failure in finding View clinical document link", 10)
        link_view_clinical_document_element.click

        switch_to_next_window

        wait_for_object(div_received_ccd_content_element, "Failure in finding received ccd content window")
        raise "Error in ccd window" if !is_text_present(self, "Radiology Imaging Continuity of Care Document")

        div_search_patient_content_element.scroll_into_view rescue Exception
        self.textfield_patient_id = str_patient_id
        click_on(button_patient_search_element)
        wait_for_object(div_patient_list_element)

        obj_task_image = table_patient_list_element.cell_element(:xpath => "./tbody[2]/tr/td[1]").image_element(:xpath => "./div/img")
        obj_task_image.focus
        obj_task_image.fire_event("onmouseover")
        wait_for_object(label_view_details_element, "Failure in finding View details link", 10)
        click_on(label_view_details_element)

        wait_for_object(div_patient_information_element, "Failure in finding Patient information iframe")
        click_on(button_attach_element)
        $log.success("The patient (#{str_patient_id}) selection from received CCD document done successfully ")
      rescue Exception => ex
        $log.error("Error while selecting patient from received CCD content : #{ex}")
        exit
      end
    end
  end
end

