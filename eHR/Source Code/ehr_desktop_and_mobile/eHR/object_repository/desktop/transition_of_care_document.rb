=begin
  *Name               : TransitionOfCare
  *Description        : module that holds methods for handling TOC document
  *Author             : Gomathi
  *Creation Date      : 11/03/2014
  *Modification Date  :
=end

module EHR
  module TransitionOfCare
    include PageObject
    include PageUtils
    include Pagination

    # Objects visible under Generated TOC document/ Generated health record window
    div(:div_submitted_ccd_content,               :id        => "ccdContent")
    table(:table_patient_details,                 :xpath     => "//div[@id='ccdContent']/table[1]")
    table(:table_visit_details,                   :xpath     => "//div[@id='ccdContent']/table[5]")
    table(:table_medication_details,              :xpath     => "//div[@id='ccdContent']/div[3]/table")
    button(:button_print_ccd_document,            :id        => "lnkPrintCCD-button")
    button(:button_download_ccd_document,         :id        => "lnkDownloadCCD-button")
    button(:button_close_ccd_document,            :id        => "abtnCancel-button")
    div(:div_download_process_message,            :id        => "message")# "Download will begin in a moment..."

    # Objects visible under submitted Transmit CCD document window
    button(:button_send_ccd_document,            :id        => "lnkSendCCD-button")
    div(:div_send_process_message,               :id        => "message")# "Sending TOC... "

    # Description        : downloads the TOC document
    # Author             : Gomathi
    #
    def download_ccd_document
      begin
        ##wait_for_loading
        switch_to_next_window       

        ##wait_for_object(div_submitted_ccd_content_element, "Failure in finding submitted ccd content window")
        raise "Error finding in ccd window" if !is_text_present(self, "Radiology Imaging Continuity of Care Document")

        button_download_ccd_document_element.scroll_into_view rescue Exception
        wait_for_object(button_download_ccd_document_element, "Failure in finding download button for CCD document")
        click_on(button_download_ccd_document_element)
        while !(File.exists?("#{File.expand_path($current_log_dir)}//Radiology Imaging_#{$str_patient_name}_CCDA.xml"))
          sleep 1
          $log.info("Waiting for the downloaded file (Radiology ImagingRadiology Imaging_#{$str_patient_name}_CCDA.xml file)")
        end
        #sleep 2 if is_text_present(self, "Download will begin in a moment...")
        $log.success("CCD document downloaded successfully")

        # close the pdf window and switch to application window
        close_application_windows
      rescue Exception => ex
        $log.error("Error while downloading Continuity of Care document : #{ex}")
        exit
      end
    end

  end
end