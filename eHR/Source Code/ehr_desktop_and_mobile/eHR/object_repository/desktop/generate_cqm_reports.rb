=begin
  *Name             : GenerateCQMReports
  *Description      : Class that contains Objects and Methods for Generate CQM Reports
  *Author           : Mani.Sundaram
  *Creation Date    : 19/03/2015
  *Modification Date:
=end

module EHR
  class GenerateCQMReports
    include PageObject
    include PageUtils
    include Pagination

    form(:form_cqm_report,                              :id        => "cqmReportForm")
    select_list(:select_EP,                             :id        => "PhysicianId")
    text_field(:textfield_from_date,                    :name      => "FromDate")
    text_field(:textfield_to_date,                      :name      => "ToDate")
    select_list(:select_category1_cqm,                  :id        => "CQM")
    button(:button_generate_category1_cqm_report,       :id        => "ActionButton1-button")
    button(:button_generate_category3_cqm_report,       :id        => "ActionButton2-button")
    button(:button_print_category3_cqm_report,          :id        => "ActionButton3-button")
    div(:div_error_msg,                                 :id        => "errorMessage")

    # description          : invoked automatically when page class object is created
    # Author               : Mani.Sundaram
    #
    def initialize_page
      wait_for_page_load
    end


    # Description        : generating the category1 CQM report
    # Author             : Mani.Sundaram
    # Arguments          :
    #   str_cqm_node     : root node of test data for CQM report
    #   str_cqm_category : pass to generate which cqm report category whether category 1/category 3
    #   str_condition    : condition for generating cqm report
    #   str_action       : action to be performed on cqm report
    #
    def generate_cqm_report(str_cqm_category, str_action, str_condition, str_cqm_node = "cqm_report_data")
      begin
        wait_for_object(form_cqm_report_element,"Failure in finding CQM Report form")
        hash_cqm = set_scenario_based_datafile(CQM_REPORT)
        object_date_time = pacific_time_calculation

        if str_condition.downcase.include?("date")
          select_EP_element.when_visible.select($str_ep_name)
          arr_condition = str_condition.downcase.split(" ")
          str_date2 = arr_condition.pop(2).join(" ")
          str_date_condition = arr_condition.pop(2).join(" ")
          str_date1 = arr_condition.pop(2).join(" ")
          if str_date1 == "from date" && str_date_condition == "greater than" && str_date2 == "to date"
            str_from_date = object_date_time + 1.days
            str_to_date = object_date_time
          elsif str_date1 == "to date" && str_date_condition == "greater than" && str_date2 == "current date"
            str_from_date = object_date_time - 1.days
            str_to_date = object_date_time + 1.days
          else
            raise "Invalid condition : #{str_condition}"
          end
        elsif str_condition.downcase == "without ep"
          str_from_date = object_date_time - 1.days
          str_to_date = object_date_time
        else
          select_EP_element.when_visible.select($str_ep_name)
          str_from_date = object_date_time - 1.days
          str_to_date = object_date_time
        end

        self.textfield_from_date = str_from_date.strftime(DATE_FORMAT)
        self.textfield_to_date = str_to_date.strftime(DATE_FORMAT)
        if str_action.downcase == "generated"
          case str_cqm_category.downcase
            when "category 1"
              select_category1_cqm_element.when_visible.select(hash_cqm[str_cqm_node]["select_category1_cqm"])
              confirm(true) do
                button_generate_category1_cqm_report_element.click
              end
            when "category 3"
              confirm(true) do
                button_generate_category3_cqm_report_element.click
              end
            else
              raise "Invalid input for str_cqm_category : #{str_cqm_category}"
          end
        elsif str_action.downcase == "printed"
          click_on(button_print_category3_cqm_report_element)
          unless div_error_msg_element.visible?
            switch_to_next_window    # switches to the window
            sleep 5
            switch_to_application_window
          end
        else
          raise "Invalid action on CQM Report : #{str_action}"
        end
        if div_error_msg_element.visible?
          $log.success("#{str_cqm_category}- Report #{str_action} successfully with condition '#{str_condition}'")
        else
          $log.success("#{str_cqm_category}- Report #{str_action} successfully")
        end
      rescue Exception => ex
        if ex.message == "undefined method `click' for nil:NilClass" && $bool_ep_inactivated
          $log.success("The Inactivated EP(#{$str_ep_name}) is not listed in Eligible Professional list")
        else
          $log.error("Error while generating #{str_cqm_category} Report : #{ex}")
          exit
        end
      end
    end

  end
end