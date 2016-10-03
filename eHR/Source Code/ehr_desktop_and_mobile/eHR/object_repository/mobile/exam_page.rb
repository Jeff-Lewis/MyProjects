=begin
  *Name             : ExamInfoPage
  *Description      : class that holds the exam creation page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class ExamInfoPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    link(:link_create_visit,                        :id        => "btnNewVisit")
    checkbox(:checkbox_count_for_mu,                :id        => "chbxFacetoFaceVisit")
    div(:div_checkbox_count_for_mu,                 :xpath     => "//form[@id='frmVisitInfo']/ul/li[1]/fieldset/div")
    select_list(:select_modality,                   :id        => "cmbModality")
    select_list(:select_cpt_code,                   :id        => "cmbCPTCodes")
    select_list(:select_ep,                         :id        => "cmbPhysician")
    text_area(:textarea_visit_notes,                :id        => "txtVisitNote")
    checkbox(:checkbox_add_visit_notes_to_clinical_summary, :id => "chbxAddVisitToEndOfExam")
    checkbox(:div_checkbox_add_visit_notes_to_clinical_summary, :xpath => "//form[@id='frmVisitInfo']/ul/li[5]/fieldset/div[2]")

    # Description          : function for adding exam data
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_exam_attribute : exam field
    #   str_exam_node      : test data node
    #
    def enter_exam_info(str_exam_attribute = "default", str_exam_node = "exam_info")
      begin
        hash_exam_yml = set_scenario_based_datafile(EXAM)
        if(str_exam_attribute.downcase.include?("unchecked count for mu")) && (checkbox_count_for_mu_element.checked?)
          div_checkbox_count_for_mu_element.click
          $log.success("Successfully unchecked Count for MU in Visit")
        end
        if str_exam_attribute.downcase.include?("unchecked add visit notes to clinical summary")
          div_checkbox_add_visit_notes_to_clinical_summary_element.scroll_into_view rescue Exception
          if checkbox_add_visit_notes_to_clinical_summary_element.checked?
            div_checkbox_add_visit_notes_to_clinical_summary_element.click
            $log.success("Successfully unchecked Count for MU in Visit")
          end
        end
        self.select_modality = hash_exam_yml[str_exam_node]["select_modality"]
        str_ep = self.select_ep
        if str_ep.strip == STAGE1_EP_NAME   # check if the current EP is global for entire application
          $log.success("The EP name(#{str_ep}) in Visit page is same as EP name(#{STAGE1_EP_NAME}) selected in EP selection page")
        else
          raise "The EP name(#{str_ep}) in Visit page is not same as EP name(#{STAGE1_EP_NAME}) selected in EP selection page"
        end
        if str_exam_attribute.downcase.include?("add visit notes")
          div_checkbox_add_visit_notes_to_clinical_summary_element.scroll_into_view rescue Exception
          self.textarea_visit_notes = hash_exam_yml[str_exam_node]["textarea_visit_notes"]
        end

        click_next
        $log.success("Successfully added exam to patient ID '#{$str_patient_id}'")
        $log.success("Test data : #{hash_exam_yml[str_exam_node]}")
      rescue Exception => ex
        $log.error("Failure in filling patient exam information : #{ex}")
        exit
      end
    end

    # Description          : function for checking if the exam attribute is updated
    # Author               : Chandra sekaran
    # Argument             :
    #   str_attribute      : exam field
    # Return argument      :
    #   bool_return        : boolean value
    #
    def is_exam_updated(str_attribute)
      begin
        bool_return = false
        if str_attribute.downcase.include? "count for mu"
          bool_status = checkbox_count_for_mu_element.checked?
          if str_attribute.downcase.include?("unchecked") &&  !bool_status
            bool_return = true
          elsif str_attribute.downcase.include?("checked") && bool_status
            bool_return = true
          end
        elsif str_attribute.downcase.include? "cpt code"
          touch(link_create_visit_element)
          tmp_cptcode = self.select_cpt_code
          bool_return = $str_cpt_code == tmp_cptcode.strip
        end
        bool_return
      rescue Exception => ex
        $log.error("Failure while checking for updated exam field '#{str_attribute}' : #{ex}")
        exit
      end
    end

  end
end