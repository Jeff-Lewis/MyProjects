=begin
  *Name               : CreateElectronicSummary
  *Description        : class that holds objects and methods for Creating Electronic Summary
  *Author             : Gomathi
  *Creation Date      : 03/23/2015
  *Modification Date  :
=end

module EHR
  class CreateElectronicSummary
    include PageObject
    include PageUtils
    include Pagination
    include TransitionOfCare

    # objects visible under Generate/ Transmit TOC document
    div(:div_transition_of_care,                  :id        => "popup_container")
    text_field(:textfield_ep_last_name,           :id        => "LastName")
    text_field(:textfield_ep_first_name,          :id        => "FirstName")
    text_field(:textfield_ep_middle_name,         :id        => "MiddleName")
    text_field(:textfield_ep_mail_id,             :id        => "Email")
    text_area(:textarea_reason,                   :id        => "Reason")
    button(:button_generate_toc_document,         :xpath     => "//div[@id='popup_container']//button[@id='lnkCreateVisit-button']")
    button(:button_transmit_toc_document,         :xpath     => "//div[@id='popup_container']//button[@id='ActionButton1-button']")
    button(:button_close_toc_document,            :xpath     => "//div[@id='popup_container']//button[@id='lnkCloseCreateVisit-button']")
    paragraph(:p_toc_related_message,             :xpath     => "//div[@id='popup_small']//p")
    button(:button_toc_message_dialog_ok,         :id        => "felixInformartiondgl-button")

    # Objects visible under generate export summary popup
    form(:form_export_summary_download,             :id     => "viewDownLoad")
    text_field(:textfield_export_summary_from_date, :name   => "FromDate")
    text_field(:textfield_export_summary_to_date,   :name   => "ToDate")
    button(:button_export_summary_ok,               :id     => "lnkexitSafteyChecker-button")
    button(:button_export_summary_cancel,           :id     => "lnkClosePolicyDialog-button")

    # description          : invoked automatically when page class object is created
    # Author               : Gomathi
    #
    def initialize_page
      wait_for_page_load
    end

    # Description        : creates a TOC document
    # Author             : Gomathi
    # Arguments          :
    #   str_toc_node     : root node of test data for TOC document
    #
    def generate_toc_document(str_toc_node = "toc_document_data")
      begin
        wait_for_object(div_transition_of_care_element)

        hash_toc = set_scenario_based_datafile(TOC_DOCUMENT)

        self.textfield_ep_last_name = hash_toc[str_toc_node]["textfield_ep_last_name"]
        self.textfield_ep_first_name = hash_toc[str_toc_node]["textfield_ep_first_name"]
        self.textfield_ep_middle_name = hash_toc[str_toc_node]["textfield_ep_middle_name"]
        self.textfield_ep_mail_id = hash_toc[str_toc_node]["textfield_ep_mail_id"]
        self.textarea_reason = hash_toc[str_toc_node]["textarea_reason"]
        wait_for_object(button_generate_toc_document_element, "Failure in finding Generate TOC document button")
        #button_generate_toc_document_element.click
        click_on(button_generate_toc_document_element)
        $log.success("Transition of Care document generated successfully")
      rescue Exception => ex
        $log.error("Error while generating Transition of Care document : #{ex}")
        exit
      end
    end

    # Description        : function for generating export summary
    # Author             : Mani.Sundaram
    #
    def generate_export_summary
      begin
        wait_for_object(form_export_summary_download_element, "Failure in finding Generate Export Summary form")
        object_date_time = pacific_time_calculation

        self.textfield_export_summary_from_date = (object_date_time - 1.days).strftime(DATE_FORMAT)
        self.textfield_export_summary_to_date = object_date_time.strftime(DATE_FORMAT)
        click_on(button_export_summary_ok_element)
        while !(File.exists?("#{File.expand_path($current_log_dir)}//Radiology Imaging.zip"))
          sleep 1
          $log.info("Waiting for the downloaded file (Radiology Imaging file)")
        end
        $log.success("Export summary generated successfully")
      rescue Exception => ex
        $log.error("Error while generating export summary : #{ex}")
        exit
      end
    end
  end
end


