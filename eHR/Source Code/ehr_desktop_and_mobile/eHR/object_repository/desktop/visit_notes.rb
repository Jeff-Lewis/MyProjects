=begin
  *Name           : VisitNotes
  *Description    : class contains method definitions for Visit Notes page
  *Author         : Chandra sekaran
  *Creation Date  : 18/09/2014
  *Updation Date  :
=end

module EHR
  class VisitNotes
    include PageObject
    include PageUtils
    include Pagination

    form(:form_visit_documents,              :id         => "visitdocuments")
    # visit notes
    div(:div_visit_notes_container,          :id         => "DivLoadVisitNote")
    select_list(:select_visit_note_type,     :id         => "VisitNoteTypeList")
    checkbox(:check_exclude_from_eoe,        :id         => "ExcludeVisitNotesFromEOE")
    select_list(:select_service_type,        :id         => "ServiceTypeList")
    text_field(:textfield_goal,              :id         => "SnomedCode_TextBox")
    textarea(:textarea_visit_note,           :id         => "VisitNote")
    button(:button_save_visit_notes,         :id         => "ActionButton32-button")
    button(:button_clear_visit_notes,        :id         => "visitNoteUpdateClearButton-button")
    table(:table_visit_notes,                :xpath      => "//div[@id='visitNotesContDiv']/table")
    div(:div_visit_notes,                    :id         => "visitNotesContDiv")
    span(:span_goal_error,                   :text       => "Please select an existing Problem")
    span(:span_visit_note_type_error,        :id         => "visitNoteListMsg")
    span(:span_save_success_msg,             :id         => "visitNoteError")
    span(:span_invalid_problem,              :id         => "lblerrorProbleminvalid")
    div(:div_visit_notes_ajax,               :xpath      => "//div[@id='SnomedCode_container']/div")

    # visit documents
    span(:span_visit_documents,              :id         => "lnkCreateProblem")
    div(:div_visit_document_list,            :id         => "patient_visit_document_list")
    table(:table_visit_document_list,        :xpath      => "//div[@id='patient_visit_document_list']/table")

    # iframe for adding visit documents
    form(:form_add_visit_document,           :id         => "frmSubmitVisitDocument")
    file_field(:filefield_upload_visit_doc,  :id         => "uploadFileVisitDocument")
    textarea(:textarea_visit_doc_note,       :id         => "VisitDocNote")
    button(:button_upload_visit_doc,         :id         => "lnkuploadVisitDocument-button")
    button(:button_close_visit_doc,          :id         => "lnkCloseUploadVisitDocumentDialog-button")

    # result report
    div(:div_results_report,                 :id         => "patient_visit_list")
    table(:table_results_report,             :xpath      => "//div[@id='patient_visit_list']/table")

    # care team members
    select_list(:select_care_team_member,    :id         => "physicianList")
    button(:button_save_member,              :id         => "careMemAddBtn-button")
    button(:button_cancel_member,            :id         => "careMemClearBtn-button")
    div(:div_care_team_members_list,         :id         => "careMemberListContDiv")
    table(:table_care_team_members_list,     :xpath      => "//div[@id='careMemberListContDiv']/table")

    link(:link_edit,                         :link_text  => "Edit")
    link(:link_delete,                       :link_text  => "Delete")
    #label(:label_date, :xpath => "//div[@id='selectedinfo']/p[3]/label[1]")

    # description          : invoked automatically when page class object is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      wait_for_page_load
      create_hashes
    end

    # Description       : creates hashes for indexing table data
    # Author            : Chandra sekaran
    #
    def create_hashes
      @hash_visit_details_table = {
          :TASK => 1,
          :VISIT_NOTE_TYPE => 2,
          :NOTES => 3,
          :ADDITIONAL_DETAILS => 4,
          :ENTERED_ON => 5
      }
      @hash_visit_documents_table = {
          :TASK => 1,
          :NAME => 2,
          :NOTE => 3,
          :USER => 4,
          :DATE => 5
      }
      @hash_results_report_table = {
          :TASK => 1,
          :EXAM_DATE => 2,
          :VISIT_ID => 3,
          :EXAM_DESCRIPTION => 4,
          :MODALITY => 5

      }
      @hash_care_team_members_table = {
          :TASK => 1,
          :NAME => 2
      }
    end

    # Description            : creates a visit notes
    # Author                 : Chandra sekaran
    # Arguments              :
    #   str_visit_notes_node : root node of test data for Visit Notes
    #
    def create_visit_notes(str_visit_notes_node = "visit_note_data")
      begin
        wait_for_object(select_visit_note_type_element, "Failure in finding visit note type select tag")

        yml_visit_notes = set_scenario_based_datafile(VISIT_NOTES)

        str_note_type = yml_visit_notes[str_visit_notes_node]["select_visit_note_type"]
        str_service_type = yml_visit_notes[str_visit_notes_node]["select_service_type"]
        str_str_goal = yml_visit_notes[str_visit_notes_node]["textfield_goal"]
        str_visit_note = yml_visit_notes[str_visit_notes_node]["textarea_visit_note"]

        select_visit_note_type_element.when_visible.select(str_note_type)
        wait_for_loading
        if select_service_type_element.visible?
          select_service_type_element.select(str_service_type)
          wait_for_loading
        end
        if textfield_goal_element.visible?
          self.textfield_goal = str_str_goal
          wait_for_object(div_visit_notes_ajax_element)
          textfield_goal_element.focus
          textfield_goal_element.send_keys(:tab)
        end
        textarea_visit_note_element.when_visible.focus
        raise "Invalid problem name(goal) : #{str_str_goal}" if span_invalid_problem_element.visible?
        self.textarea_visit_note = str_visit_note

        click_on(button_save_visit_notes_element)
        $world.puts("Test data : #{yml_visit_notes[str_visit_notes_node].to_s}")
        if is_text_present(self, "Visit Note added successfully")
          $log.success("Visit notes created successfully")
        else
          raise "Visit notes not created"
        end
      rescue Exception => ex
        $log.error("Error while creating visit notes for hash (#{yml_visit_notes[str_visit_notes_node]}): #{ex}")
        exit
      end
    end
  end
end