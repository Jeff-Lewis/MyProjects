=begin
  *Name             : AllEPReport
  *Description      : contains all objects and methods in All EP Report
  *Author           : Gomathi
  *Creation Date    : 04/09/2015
  *Modification Date:
=end

module EHR
  module AllEPReport
    include PageObject
    include PageUtils

    image(:img_ehr_logo,                :src    => "../../Content/themes/base/images/logo_AMC.png")
    image(:img_progress_bar,            :src    => "../../Content/themes/base/images/progressbar1.gif")
    button(:button_download_as_pdf,     :class  => "default_btn")
    span(:span_selected_date_range,     :css    => "#header_area>div>span")
    table(:table_stage1_ep_report,      :id     => "tblMeasureS1")
    table(:table_stage2_ep_report,      :id     => "tblMeasureS2")

    # description       : function for verifying the existence of EP
    # Author            : Gomathi
    # Arguments         :
    #   str_ep_stage    : string that denotes EP stage
    # Return argument   : boolean values
    #
    def is_ep_exists(str_ep_stage)
      begin
        wait_until(200, "All EP report is loading after 200s") { !img_progress_bar_element.visible? }
        if str_ep_stage.downcase == "stage1 ep"
          @obj_parent_table = table_stage1_ep_report_element
          str_ep_last_first_name = "#{STAGE1_EP_LAST_NAME}, #{STAGE1_EP_FIRST_NAME}"
        elsif str_ep_stage.downcase == "stage2 ep"
          @obj_parent_table = table_stage2_ep_report_element
          str_ep_last_first_name = "#{STAGE2_EP_LAST_NAME}, #{STAGE2_EP_FIRST_NAME}"
        end
        @obj_parent_table.table_elements(:xpath => "./tbody/tr").each do |ep_record|
          unless ep_record.text.downcase.include?("cpoe for medication order")
            return true if ep_record.cell_element(:xpath => "./td[1]").text.strip == str_ep_last_first_name
          end
        end
        return false
      rescue Exception => ex
        $log.error("Error while verifying existence of #{str_ep_stage} in All EP report : #{ex}")
        exit
      end
    end

  end
end

