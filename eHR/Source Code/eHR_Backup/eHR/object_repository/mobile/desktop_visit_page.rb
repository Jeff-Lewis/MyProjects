=begin
  *Name             : DesktopVisit
  *Description      : class that holds the desktop web Visit page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 05/03/2015
  *Modification Date:
=end

module EHR
  class DesktopVisit
    include PageObject
    include PageUtils

    # visit list
    table(:table_exam_visit_history,          :xpath  => "//div[@id='patient_visit_list']/table")
    link(:link_edit_visit,                    :link_text => "Edit Exam/Visit")

    # Edit visit
    link(:link_close_update_visit,            :class  => "container-close")
    div(:div_update_visit,                    :id     => "updatevisitdiv")
    checkbox(:check_count_mu,                 :id     =>  "FaceToFaceVisit")
    text_area(:textarea_note_description,     :id     =>  "Note")
    checkbox(:check_exclude_visit_notes,      :id     =>  "IsAddVisitNote")

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
      @hash_exam_table = {
          :TASK => 1,
          :ACTIVE => 2,
          :EXAM_DATE => 3,
          :EXAM_ID => 4,
          :EXAM_DESCRIPTION => 5,
          :MODALITY => 6,
          :SITE => 7
      }
    end

    # Description          : function for checking if desktop web Exam is updated
    # Author               : Chandra sekaran
    # Argument             :
    #   str_exam_attribute : exam field name
    # Return argument      :
    #   bool_status        : a boolean value
    #
    def is_exam_updated(str_exam_attribute)
      begin
        obj_image = table_exam_visit_history_element.image_element(:xpath => "#{$xpath_tbody_data_first_row}/td[#{@hash_exam_table[:TASK]}]/div/img")
        obj_image.focus rescue Exception
        obj_image.fire_event("onmouseover")
        link_edit_visit_element.click
        wait_for_loading
        wait_for_object(div_update_visit_element, "Failure in finding Update Visit div element")

        bool_status = true
        if str_exam_attribute.downcase.include? "count for mu"
          bool_status = str_exam_attribute.downcase.include?("unchecked") ? !(check_count_mu_element.checked?) : check_count_mu_element.checked?
        elsif str_exam_attribute.downcase.include? "exclude visit notes from summary"
          bool_status = str_exam_attribute.downcase.include?("unchecked") ? !(check_exclude_visit_notes_element.checked?) : check_exclude_visit_notes_element.checked?
        end
        link_close_update_visit_element.click   # close the visit iframe
        bool_status
      rescue Exception => ex
        $log.error("Error while checking for updated exam attribute(#{str_exam_attribute}) : #{ex}")
        self.execute_script("CloseDialogPopup('PopUpDivMaster');") if link_close_update_visit_element.exists?
        exit
      end
    end
  end
end