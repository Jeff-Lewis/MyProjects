=begin
  *Name             : EPPage
  *Description      : class that holds the EP selection page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class EPPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    form(:form_select_ep,                      :id       => "frmSettings")
    select_list(:select_ep,                    :id       => "cmbPhysician")
    link(:link_save_and_continue,              :id       => "btnSaveSettings")

    # Description          : function that is automatically invoked when an object of the class is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      #wait_for_object(select_ep_element, "Could not find EP select tag")
    end

    # Description    : function for selecting EP name
    # Author         : Chandra sekaran
    # Argument       :
    #   str_source   : source from which EP name is selected
    #
    def select_ep(str_source)
      begin
        if form_select_ep_element.visible? #&& select_ep_element.visible?
          if is_text_present(self, "Select a Physician to continue", 2)
            if str_source.downcase.include? "config"
              select_ep_element.select(STAGE1_EP_NAME)    # select EP from config
              str_ep = STAGE1_EP_NAME
            else
              select_ep_element.select(str_source)        # select EP from given method argument
              str_ep = str_source
            end
            touch(link_save_and_continue_element)
            $log.success("Successfully selected EP : #{str_ep}")
          end
        end
      rescue Exception => ex
        $log.error("Failure in selecting EP #{str_source} : #{ex}")
        exit
      end
    end
  end
end