=begin
  *Name             : OrderEntryLaboratory
  *Description      : module that contains all objects and methods in Laboratory tab under Order Entry tab
  *Author           : Gomathi
  *Creation Date    : 10/10/2014
  *Modification Date:
=end

module EHR
  module OrderEntryTab
    module OrderEntryLaboratory
      include PageObject
      include PageUtils
      include Pagination

      # laboratory order details
      #select_list(:select_specimen_source,     :id    => "OrderSpecimenCode")
      text_field(:textfield_collection_date,   :id        => "felix-widget-calendar-OrderCollectionDate-input")
      select_list(:select_lab_priority,        :id        => "OrderPriority")
      select_list(:select_lab_ordered_by,      :id        => "OrderedByPhysicianId")
      text_field(:textfield_lab,               :id        => "LabId_TextBox")
      div(:div_ajax_lab,                       :xpath     => "//div[@id='LabId_container']/div")
      span(:span_invalid_lab,                  :id        => "errorLab")

      checkbox(:check_lab_exclude_from_eoe,    :id        => "ExcludeLabOrderFromEOE")
      text_area(:textarea_lab_notes,           :id        => "Notes")

      text_field(:textfield_test,              :xpath     => "//div[@id='divTestList']/div/div[1]/input[1]")
      div(:div_ajax_test,                      :xpath     => "//div[@id='divTestList']/div/div/div/div/div[2]")
      span(:span_invalid_test,                 :id        => "ErrorTests")
      text_field(:textfield_number,            :id        => "TestRequiredNumber")
      select_list(:select_frequency,           :id        => "TestFrequency")

      button(:button_place_lab_order,          :id        => "lnkPlaceOrder-button")
      button(:button_cancel_lab,               :id        => "ActionButton2-button")  #xpath => "//div[@id='divLabTestAdd']//div[contains(@id,'felix_button_createLabOrderCancelActionPannel')]"

      span(:span_lab_orders,                   :id        => "lnklaborderviewAll")
      span(:span_add_results,                  :id        => "ActionButton1" )     #xpath => "//div[@id='divLabTestAdd']//div[@class='btn_addresults']//span[contains(@id,'ActionButton')]"
      span(:span_lab_results,                  :id        => "lnklabresultlistview")
      div(:div_CDS_rules_popup,                :id        => "CDSRulesValidationMessagePopup")
      span(:span_warning_popup_ok,             :id        => "lnkOK")

      # previous order of patients
      div(:div_lab_order,                      :id        => "labOrderlist")
      table(:table_lab_order,                  :xpath     => "//div[@id='labOrderlist']/table")
      link(:link_add_results,                  :link_text => "Add Results")
      link(:link_pending,                      :link_text => "Pending")

      # Previous lab results of patients
      span(:span_view_active_lab_result,       :id        => "lnkLabResultViewActive")
      span(:span_view_all_lab_result,          :id        => "lnkLabResultViewAll")
      div(:div_lab_result,                     :id        => "labOrderResultslist")
      table(:table_lab_result,                 :xpath     => "//div[@id='labOrderResultslist']/table")
      link(:link_delete_lab_result,            :link_text => "Delete")
      link(:link_inactivate_lab_result,        :link_text => "Inactivate")
      link(:link_edit_lab_result,              :link_text => "Edit")

      # Description          : creates a laboratory order
      # Author               : Gomathi
      # Arguments            :
      #   str_lab_order_node : root node of lab order test data
      #
      def create_laboratory_order(str_lab_order_node = "laboratory_order_data")
        begin
          wait_for_loading
          hash_lab_order = set_scenario_based_datafile(LABORATORY_ORDER)

          str_specimen_source = hash_lab_order[str_lab_order_node]["select_specimen_source"]
          str_lab_priority = hash_lab_order[str_lab_order_node]["select_lab_priority"]
          str_lab = hash_lab_order[str_lab_order_node]["textfield_lab"]
          str_test_half_name = hash_lab_order[str_lab_order_node]["textfield_test_half_name"]
          str_test_full_name = hash_lab_order[str_lab_order_node]["textfield_test_full_name"]
          str_number = hash_lab_order[str_lab_order_node]["textfield_number"]
          str_frequency = hash_lab_order[str_lab_order_node]["select_frequency"]

          object_date_time = pacific_time_calculation
          str_order_date = object_date_time.strftime(DATE_FORMAT)

          Selenium::WebDriver::Support::Select.new(@browser.find_element(:id, "OrderSpecimenCode")).select_by(:text, str_specimen_source)
          textfield_collection_date_element.focus
          self.textfield_collection_date = str_order_date
          select_lab_priority_element.when_visible.select(str_lab_priority)
          select_lab_ordered_by_element.when_visible.select($str_ep_name)

          self.textfield_lab = str_lab
          wait_for_object(div_ajax_lab_element, "Failure in finding div for Lab name list")
          div_ajax_lab_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
            list_item.scroll_into_view rescue Exception
            if list_item.text.downcase.strip == str_lab.downcase
              list_item.click
              break
            end
          end
          #textfield_lab_element.focus
          #textfield_lab_element.send_keys(:tab)
          sleep 1

          self.textfield_test = str_test_half_name
          wait_for_object(div_ajax_test_element, "Failure in finding div for Test list")
          div_ajax_test_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
            list_item.scroll_into_view rescue Exception
            if list_item.text.downcase.strip == str_test_full_name.downcase
              list_item.click
              break
            end
          end
          #textfield_test_element.focus
          #textfield_test_element.send_keys(:tab)
          sleep 1
          self.textfield_number = str_number
          select_frequency_element.when_visible.select(str_frequency)

          3.times {button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception
          click_on(button_place_lab_order_element)
          raise "Validation error : #{span_invalid_lab_element.text}" if span_invalid_lab_element.visible?

          raise "Could not find 'Lab Order created successfully' message" if !is_text_present(self, "Lab Order created successfully")
          $log.success("Laboratory order created successfully")
          $world.puts("Test data : #{hash_lab_order[str_lab_order_node].to_s}, select_lab_ordered_by => #{$str_ep_name}, textfield_collection_date => #{str_order_date}")
        rescue Exception => ex
          $log.error("Error while creating laboratory order : #{ex}")
          exit
        end
      end

    end
  end
end
