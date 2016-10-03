=begin
  *Name               : DocumentNote
  *Description        : module that defines method to add recent visit to document note page
  *Author             : Chandra sekaran
  *Creation Date      : 11/13/2014
  *Modification Date  :
=end

module EHR
  module PatientDocument
    module DocumentNote

      include PageObject
      include PageUtils

      div(:div_document_note_iframe,              :id    => "felix-widget-dialog-docNote-datadiv")
      form(:form_document_note,                   :id    => "ifDocFrm")
      select_list(:select_visit_name,             :id    => "VisitId")
      text_area(:textarea_visit_description,      :id    => "Note")
      button(:button_submit_document_note,        :id    => "lnkAssociateDoc-button")
      link(:link_document_note_iframe_close,      :xpath => "//div[@id='docNote']/a")

      # pop up for success message
      div(:div_document_note_popup,               :id    => "popup_small")
      button(:button_document_note_ok,            :id    => "felixInformartiondgl-button")

      # description          : method to add recent visit to document note page
      # Author               : Chandra sekaran
      #
      def submit_document_note
        begin
          wait_for_object(div_document_note_iframe_element, "Failure in finding Document note iframe")
          div_document_note_iframe_element.scroll_into_view rescue Exception

          wait_for_object(select_visit_name_element, "Failure in finding select list for visit")
          arr_visits = self.select_visit_name_options
          str_recent_visit = ""
          arr_visits.each do |str_visit|
            str_recent_visit = str_visit if str_visit.include? $arr_all_exam_id.last
          end

          self.select_visit_name = str_recent_visit
          #self.textarea_visit_description = "some data"
          click_on(button_submit_document_note_element)
          wait_for_object(div_document_note_popup_element, "Failure in finding document note success message popup")
          button_document_note_ok_element.when_visible.click
          wait_for_loading
          $log.success("The recent visit is added to document note iframe successfully")

          # close the pdf window and switch to application window
          switch_to_application_window
        rescue Exception => ex
          $log.error("Error while submitting document note : #{ex}")
          exit
        end
      end

    end
  end
end