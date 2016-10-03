=begin
  *Name           : OrderEntry
  *Description    : class method definitions for Order entry/Results module
  *Author         : Chandra sekaran
  *Creation Date  : 10/01/2014
  *Updation Date  :
=end

module EHR
  class OrderEntryResults < MasterPage
    include PageObject
    include PageUtils
    include Pagination
    include OrderEntryTab::OrderEntryMedications    # for Medications
    include OrderEntryTab::OrderEntryRadiology      # for Radiology
    include OrderEntryTab::OrderEntryLaboratory     # for Laboratory
    include OrderEntryTab::LabResults               # for Lab Results

    form(:form_order_entry_details,          :id         => "orderentrydetails")

    # menu header under Order entry page
    link(:link_lab,                          :link_text  => "Lab")
    link(:link_radiology,                    :link_text  => "Radiology")
    link(:link_medications,                  :link_text  => "Medications")
    link(:link_reports,                      :link_text  => "Reports")

    # Objects common to Medication order, Radiology order and lab Order
    select_list(:select_priority,            :id         => "PriorityValueCode")
    link(:link_view,                         :link_text  => "View")
    link(:link_cancel,                       :link_text  => "Cancel")
	link(:link_complete,                     :link_text  => "Complete")
    button(:button_add,                      :xpath      => "//div[@class='btn_add']/a")

    # Objects visible under Lab Order information form
    form(:form_lab_order_info,               :id         => "openlabsresultsform")
    div(:div_lab_order_list_in_form,         :id         => "labOrderlistrslt")
    table(:table_lab_order_list_in_form,     :xpath      => "//div[@id='labOrderlistrslt']/table")
    button(:button_close_lab_order_info,     :id         => "lnkCloseCreatePatient-button")
    link(:link_add_result,                   :link_text  => "Add Result")

    # description          : invoked automatically when page class object is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      create_hash

      # valid lab result affirmation
      @arr_valid_affirmation = ["numeric affirmation", "positive affirmation", "negative affirmation"]
    end

    # Description       : creates hash for indexing table data
    # Author            : Gomathi
    #
    def create_hash
      @hash_medication_details_table = {
          :TASK => 1,
          :EXCLUDE => 2,
          :DATE_ORDER_PLACED => 3,
          :MEDICATION => 4,
          :DRUG_FORMAT => 5,
          :DOSE_UNIT => 6,
          :STATUS => 7,
          :CODE_TYPE => 8
      }

      @hash_radiology_details_table = {
          :TASK => 1,
          :EXCLUDE => 2,
          :ORDER_DATE => 3,
          :ORDER_NUMBER => 4,
          :EXAM_DESCRIPTION => 5,
          :STATUS => 6
      }

      @hash_laboratory_details_table = {
          :TASK => 1,
          :EXCLUDE => 2,
          :ORDER_DATE => 3,
          :ORDER_NUMBER => 4,
          :ORDERED_BY => 5,
          :LAB_NAME => 6,
          :STATUS => 7
      }

      @hash_lab_results_details_table = {
          :TASK => 1,
          :TEST_REPORTED_DATE => 2,
          :TEST_PERFORMED => 3,
          :RESULT_TYPE => 4,
          :TEST_RESULT => 5,
          :TEST_UNITS => 6,
          :ABNORMAL_FLAG => 7,
          :LOINC_CODE => 8,
          :STATUS => 9
      }

      @hash_lab_order_info_table = {
          :TASK => 1,
          :TEST => 2,
          :NUMBER => 3,
          :FREQUENCY => 4
      }
    end

    # description     : cancel the existing medication order
    # Author          : Chandra sekaran
    # Arguments       :
    #   str_order     : String that denotes type of order
    #
    def cancel_existing_order(str_order)
      begin
        wait_for_loading
        case str_order.downcase
          when "medication order"
            @obj_parent_table = table_medication_order_element
            @hash_table_name = @hash_medication_details_table
            3.times { button_place_medication_order_element.send_keys(:arrow_down) } rescue Exception
          when "radiology order"
            @obj_parent_table = table_radiology_order_element
            @hash_table_name = @hash_radiology_details_table
            3.times { button_place_radiology_order_element.send_keys(:arrow_down) } rescue Exception
          when "laboratory order"
            3.times { button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception
            click_on(span_lab_orders_element)
            wait_for_loading
            @obj_parent_table = table_lab_order_element
            @hash_table_name = @hash_laboratory_details_table
          else
            raise "Invalid order type : #{str_order}"
        end
        ##sleep 5 # static delay for sync issue
        wait_for_object(@obj_parent_table, "Failure in finding Previous orders table of #{str_order}")
		@obj_parent_table.scroll_into_view rescue Exception
        3.times { @obj_parent_table.send_keys(:arrow_down) } rescue Exception
        ##sleep 3  # static delay for sync issue
        @str_row = nil
        if @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end

        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          raise "No records found in Previous orders table of #{str_order}"
        else
          sleep 1 until !@obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).visible?
        end

        str_status = @obj_parent_table.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_table_name[:STATUS]}]").when_visible.text.strip

        if str_status.downcase != "canceled" or str_status.downcase != "cancelled"
          obj_image_task = @obj_parent_table.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_table_name[:TASK]}]").image_element(:xpath => "./div/img")
          obj_image_task.when_visible.focus
          obj_image_task.when_visible.fire_event("onmouseover")

          message = confirm(true) do      # clicks 'Ok' button on the confirm message box
            link_cancel_element.when_visible.click
          end
          wait_for_loading
          sleep 5  # static delay for sync issue
          wait_for_object(@obj_parent_table, "Failure in finding Previous orders table of #{str_order}")
          @obj_parent_table.scroll_into_view rescue Exception
          3.times { @obj_parent_table.send_keys(:arrow_down) } rescue Exception
          sleep 3  # static delay for sync issue
          @str_row = nil
          if @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).exists?
            obj_tr = @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row)
            if obj_tr.visible?
              @str_row = obj_tr.text.strip
            end
          end

          if !@str_row.nil? && @str_row.downcase.include?("no records found")
            raise "No records found in Previous orders table of #{str_order}"
          else
            sleep 1 until !@obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).visible?
          end

		  str_new_status = @obj_parent_table.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_table_name[:STATUS]}]").when_visible.text.strip
		
          if str_new_status.downcase == "canceled" or str_new_status.downcase == "cancelled"
            $log.success("#{str_order} is cancelled successfully")
          else
            raise "#{str_order} status is not updated to 'Canceled' after cancelling the order"
          end
        else
          raise "The #{str_order} is cancelled already"
        end
        if str_order.downcase == "medication order"
          $num_hand_written_medication_order -= 1 if $num_hand_written_medication_order != 0
        elsif str_order.downcase == "radiology order"
          $num_radiology_order -= 1 if $num_radiology_order != 0 && $user.downcase != "non ep"
        elsif str_order.downcase == "laboratory order"
          $num_laboratory_order -= 1 if $num_laboratory_order != 0 && $user.downcase != "non ep"
          $num_clinical_lab_results -= 1 if $num_clinical_lab_results != 0
        end
      rescue Exception => ex
        $log.error("Error while cancelling the recent #{str_order} : #{ex}")
        exit
      end
    end

    # description          : creates a new order
    # Author               : Gomathi
    # Arguments            :
    #   str_order          : string that denotes type of order
    #   str_report_range   : reporting period ;whether within or outside reporting period
    #
    def create_new_order(str_order_count, str_order, str_report_range)
      case str_order.downcase
        when "radiology order"
          select_tab(str_order)
          wait_for_object(button_place_radiology_order_element, "Failure in finding 'Place Order' button of #{str_order}")
          3.times { button_place_radiology_order_element.send_keys(:arrow_down) } rescue Exception
          num_record_count = get_table_row_count(div_radiology_order_element)

          str_order_count.to_i.times do
            create_radiology_order
          end

          wait_for_object(button_place_radiology_order_element, "Failure in finding 'Place Order' button of #{str_order} after placing order")
          3.times { button_place_radiology_order_element.send_keys(:arrow_down) } rescue Exception
          num_new_record_count = get_table_row_count(div_radiology_order_element)

          if num_new_record_count == num_record_count + str_order_count.to_i
            $num_radiology_order += str_order_count.to_i if $user.downcase != "non ep"   # count no of radiology orders
            $log.success("Radiology order is available in Radiology orders table")
          else
            raise "Radiology order is not available in Radiology orders table"
          end

        when "laboratory order"
          select_tab(str_order)
          wait_for_object(button_place_lab_order_element, "Failure in finding 'Place Order' button of #{str_order}")
          3.times { button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception
          click_on(span_lab_orders_element)
          num_record_count = get_table_row_count(div_lab_order_element)

          str_order_count.to_i.times do
            create_laboratory_order
          end

          wait_for_object(button_place_lab_order_element, "Failure in finding 'Place Order' button of #{str_order} after placing order")
          3.times { button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception
          click_on(span_lab_orders_element)
          num_new_record_count = get_table_row_count(div_lab_order_element)

          if num_new_record_count == num_record_count + str_order_count.to_i
            $num_laboratory_order += str_order_count.to_i if $user.downcase != "non ep"   # count no of laboratory orders
            if str_report_range.downcase.strip == "within reporting period"
              $str_lab_order = "valid"
            else
              $str_lab_order = "invalid"
            end
            $log.success("Laboratory order is available in Lab orders table")
          else
            raise "Laboratory order is not available in Lab orders table"
          end

        when /medication order/
          select_tab("medication order")
          wait_for_object(button_place_medication_order_element, "Failure in finding 'Place Order' button of #{str_order}")
          3.times { button_place_medication_order_element.send_keys(:arrow_down) } rescue Exception
          num_record_count = get_table_row_count(div_medication_order_element)

          if str_order.downcase == "hand written medication order"
            str_order_count.to_i.times do
              create_medication_order(str_order)
              if $user.downcase == "stage1 ep"
                $num_s1_medication_order += 1
              else
                $num_hand_written_medication_order += 1     # count no of hand written medication orders
              end
            end

          elsif str_order.downcase == "e-prescribed medication order"
            num_test_data_count = 1
            str_order_count.to_i.times do
              create_medication_order(str_order, "medication_order_data#{num_test_data_count}")
              num_test_data_count += 1
              if $user.downcase == "stage1 ep"
                $num_s1_medication_order += 1
                $num_s1_e_prescribed_medication_order += 1    # count no of e-prescribed medication orders
              elsif $user.downcase == "stage2 ep"
                $num_s2_e_prescribed_medication_order += 1    # count no of e-prescribed medication orders
              end
            end

          elsif str_order.downcase.include?("medication order from master list")
            sleep 3
            click_on(check_order_drug_from_master_element)
            create_medication_order(str_order)
            $num_s1_e_prescribed_medication_order += 1 if $user.downcase == "stage1 ep" && str_order.downcase.include?("e-prescribed")

          elsif str_order.downcase == "medication order with controlled substance"
            create_medication_order(str_order, "medication_order_controlled")

          else
            raise "Invalid medication order type : #{str_order}"
          end

          wait_for_object(button_place_medication_order_element, "Failure in finding 'Place Order' button of #{str_order} after placing order")
          3.times { button_place_medication_order_element.send_keys(:arrow_down) } rescue Exception
          num_new_record_count = get_table_row_count(div_medication_order_element)

          if num_new_record_count == num_record_count + str_order_count.to_i
            $log.success("Medication order is available in Medication orders table")
          else
            raise "Medication order is not available in Medication orders table"
          end
        else
          raise "Invalid order type : #{str_order}"
      end
    end

    # description          : returns the status of order
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_order          : string that denotes type of order
    # Return argument      :
    #   str_status         : status of the order
    #
    def get_order_status(str_order)
      begin
        wait_for_loading
        case str_order.downcase
          when "medication order"
            # do nothing
          when "radiology order"
            @obj_parent_table = table_radiology_order_element
            @hash_table_name = @hash_radiology_details_table
            3.times { button_place_radiology_order_element.send_keys(:arrow_down) } rescue Exception
          when "laboratory order"
            # do nothing
          when "laboratory results"
            @obj_parent_table = table_lab_result_element
            @hash_table_name = @hash_lab_results_details_table
            3.times { button_place_lab_order_element.when_visible.send_keys(:arrow_down) } rescue Exception
          else
            raise "Invalid order type : #{str_order}"
        end
        ##sleep 5 # static delay for sync issue
        wait_for_object(@obj_parent_table, "Failure in finding Previous orders table of #{str_order}")
        3.times { @obj_parent_table.send_keys(:arrow_down) } rescue Exception
        ##sleep 3  # static delay for sync issue
        @str_row = nil
        if @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = @obj_parent_table.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end

        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          raise "No records found in Previous orders table of #{str_order}"
        else
          sleep 1 until !@obj_parent_table.table_element(:xpath => $xpath_tbody_message_row).visible?
        end

        str_status = @obj_parent_table.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_table_name[:STATUS]}]").when_visible.text.strip
        return str_status   # returns the status of order in first row of the table
      rescue Exception => ex
        $log.error("Error while fetching status for '#{str_order}' : #{ex}")
        exit
      end
    end

    # description          : creates a lab result
    # Author               : Gomathi
    # Arguments            :
    #   str_affirmation    : string that denotes type of result affirmation
    #   str_report_range   : reporting period ;whether within or outside reporting period
    #   str_report_date    : string that denotes lab result report date
    #
    def add_lab_result(str_affirmation, str_report_range, str_report_date)
      begin
        wait_for_object(button_place_lab_order_element, "Failure in finding 'Place Order' button of Laboratory order")
        3.times { button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception

        num_result_count = get_table_row_count(div_lab_result_element)
        click_on(span_lab_orders_element)
        num_record_count = get_table_row_count(div_lab_order_element)
        if num_record_count != 0
          obj_image_task = table_lab_order_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_laboratory_details_table[:TASK]}]").image_element(:xpath => "./div/img")
          obj_image_task.when_visible.focus
          obj_image_task.when_visible.fire_event("onmouseover")
          link_add_results_element.click

          #wait_for_object(form_lab_order_info_element, "Failure in finding Lab order information iframe")
          ##sleep 3
          #obj_image_task = table_lab_order_list_in_form_element.when_visible.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_lab_order_info_table[:TASK]}]").image_element(:xpath => "./div/img")
          #obj_image_task.when_visible.focus
          #obj_image_task.when_visible.fire_event("onmouseover")
          #link_add_result_element.click

          #wait_for_object(link_add_result_element, "Could not find add result link", 10) rescue Exception
          #if !link_add_result_element.exists?
          #obj_image_task.when_visible.focus
          #obj_image_task.when_visible.fire_event("onmouseover")
          #end
          #link_add_result_element.click
          #if !is_text_present(self, "Create Lab Result", 10)
          #  #obj_image_task.when_visible.focus
          #  obj_image_task.when_visible.fire_event("onmouseover")
          #  @browser.find_element(:css, "a.yuimenuitemlabel > label").click
          #end
          if is_text_present(self, "Lab Order Information")
            obj_image_task = table_lab_order_list_in_form_element.when_visible.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_lab_order_info_table[:TASK]}]").image_element(:xpath => "./div/img")
            obj_image_task.when_visible.fire_event("onmouseover")
            @browser.find_element(:css, "a.yuimenuitemlabel > label").click
          else
            raise "Lab order information iframe not found"
          end
          wait_for_loading

          create_lab_result(str_affirmation, str_report_date)
          click_on(button_save_result_element)
          if is_text_present(self, "Create Lab Result", 10)
            button_save_result_element.click
          end
          ##wait_for_object(form_lab_order_info_element, "Failure in finding Lab order information iframe")
          raise "Lab result not created successfully" if !is_text_present(self, "Results for all test have been received .")
          click_on(button_close_lab_order_info_element)

        else
          click_on(span_add_results_element)
          create_lab_result(str_affirmation, str_report_date)

          click_on(button_save_and_close_result_element)
          if is_text_present(self, "Create Lab Result", 10)
            button_save_and_close_result_element.click
          end
          raise "Validation error : #{span_invalid_lab_element.text}" if span_invalid_lab_element.visible?
          raise "Validation error : #{span_invalid_test_performed_element.text}" if span_invalid_test_performed_element.visible?
        end
        raise "Lab result not created successfully" if is_text_present(self, "Create Lab Result", 2)
        $log.success("Lab result created successfully")
        wait_for_object(span_lab_results_element)
        click_on(span_lab_results_element)

        #if div_CDS_rules_popup_element.exists?
        #click_on(span_warning_popup_ok_element)
        # sleep 1
        #end

        num_new_result_count = get_table_row_count(div_lab_result_element)

        if num_new_result_count == num_result_count + 1
          if (@arr_valid_affirmation.include?(str_affirmation)) && (($str_lab_order == "" && str_report_range.downcase.strip == "within reporting period") || $str_lab_order == "valid")
            $num_clinical_lab_results += 1
          end
          $log.success("Lab result is available in Lab results table")
        else
          raise "Lab result is not available in Lab results table"
        end
      rescue Exception => ex
        $log.error("Error while adding lab results : #{ex}")
        exit
      end
    end

    # description          : edits the latest lab result record
    # Author               : Gomathi
    # Arguments            :
    #   str_action         : action denotes Inactivating or Deleting the record
    #
    def edit_lab_result(str_action)
      begin
        wait_for_object(button_place_lab_order_element, "Failure in finding 'Place Order' button of Laboratory order")
        3.times { button_place_lab_order_element.send_keys(:arrow_down) } rescue Exception

        wait_for_object(table_lab_result_element, "Failure in finding Previous Lab results table")
        3.times { table_lab_result_element.send_keys(:arrow_down) } rescue Exception
        #sleep 3  # static delay for sync issue
        @str_row = nil
        if table_lab_result_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_lab_result_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end

        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          raise "No records found in Previous Lab results table"
        else
          sleep 1 until !table_lab_result_element.table_element(:xpath => $xpath_tbody_message_row).visible?
        end

        str_status = table_lab_result_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_lab_results_details_table[:STATUS]}]").when_visible.text.strip

        if str_status.downcase == "active"
          num_old_row_count = get_table_row_count(div_lab_result_element)

          obj_image_task = table_lab_result_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_lab_results_details_table[:TASK]}]").image_element(:xpath => "./div/img")
          obj_image_task.when_visible.focus
          obj_image_task.when_visible.fire_event("onmouseover")

          case str_action.downcase
            when "inactivated"
              click_on(link_inactivate_lab_result_element)
            when "deleted"
              message = confirm(true) do      # clicks 'Ok' button on the confirm message box
                link_delete_lab_result_element.when_visible.click
              end
            else
              raise "Invalid action for lab results : #{str_action}"
          end

          num_new_row_count = get_table_row_count(div_lab_result_element)
          raise "#{str_action.capitalize} lab result is not reflected in Lab Results table" if (num_old_row_count - 1) != num_new_row_count

          if str_action.downcase == "inactivated"
            click_on(span_view_all_lab_result_element)
            str_new_status = table_lab_result_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_lab_results_details_table[:STATUS]}]").when_visible.text.strip
            raise "Record for lab result is not present under Inactive status" if !(str_new_status.downcase == "inactive")
          end
        else
          raise "Lab result is not in Activated status, the status is #{str_status}"
        end

        $num_clinical_lab_results -= 1 if $num_clinical_lab_results != 0
        $log.success("Lab Result is edited to '#{str_action}' status successfully")
      rescue Exception => ex
        $log.error("Error while edit Lab result to #{str_action} status : #{ex}")
        exit
      end
    end

  end
end