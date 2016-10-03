=begin
  *Name               : CreateExam
  *Description        : class to create / edit the  Exam / Visit details of the patient
  *Author             : Gomathi
  *Creation Date      : 25/08/2014
  *Modification Date  :
=end

module EHR
  class CreateExam

    include PageObject
    include DataMagic
    include PageUtils
    include FileLibrary

    form(:form_create_exam_visit,             :id     =>  "createvisitfrm")
    link(:link_close_create_exam_visit,       :class  =>  "container-close")
    div(:div_create_exam_visit_content,       :id     =>  "createvisitdiv")

    #Visit Information
    checkbox(:check_count_mu,                 :id     =>  "FaceToFaceVisit")
    text_field(:textfield_visit_id,           :id     =>  "VisitID")
    text_field(:textfield_visit_date,         :id     =>  "felix-widget-calendar-VisitDateStr-input")
    select_list(:select_visit_time,           :id     =>  "VisitTimeHours")
    text_field(:textfield_visit_minutes,      :id     =>  "VisitTimeMinutes")
    select_list(:select_visit_meridian,       :id     =>  "VisitTimeMeridiem")
    text_field(:textfield_visit_duration,     :id     =>  "VisitDurationMinutes")
    select_list(:select_cpt_code,             :id     =>  "CPTCode")
    select_list(:select_physician_id,         :id     =>  "PhysicianId")
    select_list(:select_modality_code,        :id     =>  "ModalityCode")
    text_field(:textfield_procedure,          :id     =>  "ExamDescriptionCode_TextBox")
    div(:div_procedure_ajax,                  :xpath  => "//div[@id='ExamDescriptionCode_container']/div")
    select_list(:select_site_code,            :id     =>  "SiteCode")
    text_field(:textfield_refer_physician,    :id     =>  "ReferringPhysician")
    radio_button(:radio_inpatient,            :value  =>  "I")    # Both Inpatient & Outpatient contains the same name
    radio_button(:radio_outpatient,           :value  =>  "O")

    #Visit Notes
    text_area(:textarea_visit_note,           :id     =>  "Note")
    text_area(:textarea_visit_facility,       :id     =>  "Address1Street2")
    text_area(:textarea_visit_coded,          :id     =>  "SnomedCode_TextBox")
    div(:div_visit_coded_container,           :xpath  =>  "//div[@id='SnomedCode_container']/div")
    text_area(:textarea_chief_complaint,      :id     =>  "ChiefComplaint")
    checkbox(:check_include_visit_info,       :id     =>  "ExcludeExamProcedureFromEOE")
    checkbox(:check_exclude_visit_notes,      :id     =>  "IsAddVisitNote")
    checkbox(:check_send_visit_info_to_phr,   :id     =>  "DoNotSendToPHR")

    #Button details
    button(:button_save_add_more_exam,        :xpath  =>  "//div[@id='create_patient']//button[text()='Save/Add More']")
    button(:button_save_close_exam,           :id     =>  "ActionButton1-button")  #xpath => "//form[@id="createvisitfrm"]//div[@class='btn_container']//div[2]/span"
    button(:button_cancel_exam,               :xpath  =>  "//div[@id='create_patient']//button[text()='Cancel']")

    # Objects for Update visit
    form(:form_update_visit,                  :id     => "updatevisitfrm")
    link(:link_close_update_visit,            :class  => "container-close")
    div(:div_update_visit,                    :id     => "updatevisitdiv")
    button(:button_save_edited_exam,          :id     => "lnkEditVisit-button")

    # description  : Function will get invoked when object for page class is created
    # Author       : Gomathi
    #
    def initialize_page
      wait_for_page_load
    end

    # description          : function to populate data for create exam/visit
    # Author               : Gomathi
    # Arguments            :
    #   str_exam_attribute : describes exam's characteristics
    #   str_exam_time      : describes exam creation date and time
    #   str_exam_node      : root data node for Exam
    # Return argument      : textfield_visit_id
    #
    def create_exam(str_exam_attribute, str_exam_time, str_exam_node = "exam_data")
      begin
        wait_for_object(div_create_exam_visit_content_element, "Failure in finding div for create exam/visit")
        str_exam_node = "exam_data_for_patient_education_modality" if str_exam_attribute.downcase.include?("patient education modality")
        hash_exam_yml = set_scenario_based_datafile(EXAM)

        str_count_mu = hash_exam_yml[str_exam_node]["check_count_mu"]
        str_cpt_code = hash_exam_yml[str_exam_node]["select_cpt_code"]
        str_procedure = hash_exam_yml[str_exam_node]["textfield_procedure"]

        if str_count_mu.downcase == "true"
          check_check_count_mu
        elsif str_count_mu.downcase == "false"
          uncheck_check_count_mu
        else
          raise "Invalid input for 'check_count_mu' : #{str_count_mu}"
        end

        self.textfield_visit_date = str_exam_time.strftime(DATE_FORMAT)
        num_new_time = str_exam_time.strftime("%I").to_i
        select_visit_time_element.select(num_new_time.to_s)
        self.textfield_visit_minutes = str_exam_time.strftime("%M")
        select_visit_meridian_element.select(str_exam_time.strftime("%p"))

        if !str_cpt_code.nil?
          select_cpt_code_element.when_visible.select(str_cpt_code) if str_exam_attribute.downcase == "active with cpt code"
        end

        if str_exam_attribute.downcase.include?("other ep")
          select_physician_id_element.when_visible.select(STAGE2_EP_NAME)
        elsif !(str_exam_attribute.downcase.include?("no ep"))
          select_physician_id_element.when_visible.select($str_ep_name)
        end

        select_modality_code_element.when_visible.select(hash_exam_yml[str_exam_node]["select_modality_code"])
        if str_exam_attribute.downcase.include?("other site")
          select_site_code_element.when_visible.select(SITE_NAME2)
        elsif str_exam_attribute.downcase.include?("no site")
          # do nothing
        elsif str_exam_attribute.downcase.include?("site")
          $log.info("---Site Code values : #{select_site_code_options}")
          select_site_code_element.when_visible.select(SITE_NAME1)
        end

        if !str_procedure.nil?
          self.textfield_procedure = str_procedure
          wait_for_object(div_procedure_ajax_element)
          textfield_procedure_element.send_keys(:tab)
        end

        $world.puts("Test data : #{hash_exam_yml.to_s}, EP name => #{$str_ep_name}")
        $world.puts("Test data : Exam date and time => #{str_exam_time.strftime("%m/%d/%Y %I:%M:%S %p")}")
        $log.success("Data population for create exam/visit done successfully")
        return textfield_visit_id
      rescue Exception => ex
        $log.error("Error while populating data for create exam/visit : #{ex}")
        exit
      end
    end

    # description          : function to create a exam/visit for a patient
    # Author               : Gomathi
    # Arguments            :
    #   str_exam_attribute : describes exam's characteristics
    #   str_exam_time      : describes exam creation date and time
    # Return argument      : str_exam_id
    #
    def save_close_for_create_exam_visit(str_exam_attribute, str_exam_time)
      begin
        str_exam_id = create_exam(str_exam_attribute, str_exam_time)
        case str_exam_attribute.downcase
          when ""
            click_on(button_save_close_exam_element)
          when "mu unchecked"
            uncheck_check_count_mu
            $world.puts("Test data (update) : MU unchecked")
            click_on(button_save_close_exam_element)
          when /inpatient/
            select_radio_inpatient
            $world.puts("Test data (update) : Inpatient")
            click_on(button_save_close_exam_element)
          when /inactive/
            click_on(button_save_close_exam_element)
          when "send visit information to phr unchecked"
            uncheck_check_send_visit_info_to_phr
            $world.puts("Test data (update) : send visit information to PHR unchecked")
            click_on(button_save_close_exam_element)
          when /active/, "outpatient", "mu checked", "within reporting period", "within report range", "active with cpt code"
            click_on(button_save_close_exam_element)
            $arr_valid_exam_id << str_exam_id
          else
            raise "Invalid exam attribute : #{str_exam_attribute}"
        end
        return str_exam_id
      rescue Exception => ex
        $log.error("Error while creating exam/visit for a patient : #{ex}")
        exit
      end
    end

    # description          : function to create more exam/visit for a patient
    # Author               : Gomathi
    # Arguments            :
    #   str_exam_attribute : describes exam's characteristics
    #   str_exam_time      : describes exam creation date and time
    # Return argument      : str_exam_id
    #
    def save_add_more_for_create_exam_visit(str_exam_attribute, str_exam_time)
      begin
        str_exam_id = create_exam(str_exam_attribute, str_exam_time)
        case str_exam_attribute.downcase
          when ""
            click_on(button_save_add_more_exam_element)
          when "mu unchecked"
            uncheck_check_count_mu
            $world.puts("Test data (update) : MU unchecked")
            click_on(button_save_add_more_exam_element)
          when "inpatient"
            select_radio_inpatient
            $world.puts("Test data (update) : Inpatient")
            click_on(button_save_add_more_exam_element)
          when "inactive"
            click_on(button_save_add_more_exam_element)
          when "send visit information to phr unchecked"
            uncheck_check_send_visit_info_to_phr
            $world.puts("Test data (update) : send visit information to PHR unchecked")
            click_on(button_save_add_more_exam_element)
          when "active", "outpatient", "mu checked", "within reporting period", "within report range", "active with cpt code"
            click_on(button_save_add_more_exam_element)
            $arr_valid_exam_id << str_exam_id
          else
            raise "Invalid exam attribute : #{str_exam_attribute}"
        end
        return str_exam_id
      rescue Exception => ex
        $log.error("Error while creating exam/visit for a patient : #{ex}")
        exit
      end
    end

    # Description          : updates the given exam attributes for the currently opened visit
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_exam_attribute : exam attribute to be updated
    #   str_action         : update action to be performed
    #   str_exam_node      : test data node
    #
    def update_visit(str_exam_attribute, str_action, str_exam_node = "exam_data")
      begin
        wait_for_object(div_update_visit_element, "Could not find Update Visit deiv element")
        hash_exam_yml = set_scenario_based_datafile(EXAM)
        case str_exam_attribute.downcase
          when "note description"
            str_visit_note = hash_exam_yml[str_exam_node]["textarea_visit_note"]
            tmp_data = self.textarea_visit_note
            if !tmp_data.nil? && !tmp_data.empty?
              $log.success("The #{str_exam_attribute} of current exam has already been updated") if tmp_data.strip.downcase == str_visit_note.downcase
            else
              self.textarea_visit_note = str_visit_note
            end
          when "count for mu"
            if str_action.downcase == "checked"
              check_check_count_mu if !check_count_mu_checked?
            elsif str_action.downcase == "unchecked"
              uncheck_check_count_mu if check_count_mu_checked?
            end
          when "reason for visit(coded) and chief compliant"
            button_save_edited_exam_element.scroll_into_view rescue Exception
            str_reason_for_visit = hash_exam_yml[str_exam_node]["textarea_visit_coded"]
            self.textarea_visit_coded = str_reason_for_visit
            wait_for_object(div_visit_coded_container_element, "Failure in finding Visit Coded elements container")
            textarea_visit_coded_element.send_keys(:arrow_down)
            textarea_visit_coded_element.send_keys(:tab)
            str_chief_compliant = hash_exam_yml[str_exam_node]["textarea_chief_complaint"]
            self.textarea_chief_complaint = str_chief_compliant
          else
            raise "Invalid Exam attribute : #{str_exam_attribute}"
        end
        click_on(button_save_edited_exam_element)
        $log.success("#{str_exam_attribute} field of the current exam has been updated")
      rescue Exception => ex
        $log.error("Error while updating visit (#{str_exam_attribute}) for patient (#{$str_patient_id}) in Non Compliance Report page : #{ex}")
        exit
      end
    end

    # Description          : checks if the visit attributes are updated
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_exam_attribute : exam attribute to be checked
    #   str_exam_node      : test data node
    #
    def is_visit_updated(str_exam_attribute, str_exam_node = "exam_data")
      begin
        hash_exam_yml = set_scenario_based_datafile(EXAM)
        bool_status = true
        case str_exam_attribute.downcase
          when "note description"
            str_expected_visit_note = hash_exam_yml[str_exam_node]["textarea_visit_note"]
            str_actual_visit_note = self.textarea_visit_note
            if str_actual_visit_note.strip.downcase != str_expected_visit_note.downcase
              $log.error("Actual visit data '#{str_exam_attribute}' [#{str_actual_visit_note}] is not equal to Expected data [#{str_expected_visit_note}]")
              bool_status = false
            end
          when "reason for visit(coded) and chief compliant"
            button_save_edited_exam_element.scroll_into_view rescue Exception
            str_reason_for_visit = hash_exam_yml[str_exam_node]["textarea_visit_coded"]
            str_chief_compliant = hash_exam_yml[str_exam_node]["textarea_chief_complaint"]
            tmp_visit_coded = self.textarea_visit_coded
            if tmp_visit_coded.strip.split("-").last.strip.downcase != str_reason_for_visit.split("-").last.strip.downcase
              $log.error("Actual visit data '#{str_exam_attribute}' [#{tmp_visit_coded}] is not equal to Expected data [#{str_reason_for_visit}]")
              bool_status = false
            end
            tmp_chief_compliant = self.textarea_chief_complaint
            if tmp_chief_compliant.strip.downcase != str_chief_compliant.downcase
              $log.error("Actual visit data '#{str_exam_attribute}' [#{tmp_chief_compliant}] is not equal to Expected data [#{str_chief_compliant}]")
              bool_status = false
            end
          else
            raise "Invalid Exam attribute : #{str_exam_attribute}"
        end
        click_on(link_close_update_visit_element)
        #$log.success("Test data : #{hash_exam_yml[str_exam_node]}")
        bool_status
      rescue Exception => ex
        $log.error("Error while updating visit (#{str_exam_attribute}) for patient (#{$str_patient_id}) in Non Compliance Report page : #{ex}")
        exit
      end
    end

  end
end