=begin
  *Name           : OrderEntryMedications
  *Description    : module that holds objects and method definitions for Medications under Order entry tab
  *Author         : Chandra sekaran
  *Creation Date  : 10/01/2014
  *Updation Date  :
=end

module EHR
  module OrderEntryTab
    module OrderEntryMedications
      include PageObject
      include PageUtils
      include Pagination

      # patient details
      span(:span_patient_name,                    :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[1]")
      span(:span_patient_id,                      :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[2]")
      span(:span_dob,                             :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[3]")
      span(:span_sex,                             :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[4]")
      span(:span_address,                         :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[5]")
      span(:span_preferred_phone,                 :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[6]")
      span(:span_email,                           :xpath     => "//div[@id='divMedicationOrderMain']/div[1]/div[1]/p/span[7]")

      # medication order details
      select_list(:select_medication_ordered_by,  :id        => "MedOrderById")
      select_list(:select_pharmacy,               :id        => "Pharmacy")
      checkbox(:check_exclude_medication_from_eoe,:id        => "ExcludeMedicationOrderFromEOE")
      text_area(:textarea_medication_notes,       :id        => "MedicationNotes")

      checkbox(:check_order_drug_from_master,     :id        => "OrderDrugFromMaster")

      text_field(:textfield_medication,           :id        => "MedicationCode_TextBox")
      text_field(:textfield_master_medication,    :id        => "MasterMedicationCode_TextBox")
      div(:div_medication_ajax,                   :xpath     => "//div[@id='MedicationCode_container']/div")
      div(:div_master_medication_ajax,            :xpath     => "//div[@id='MasterMedicationCode_container']/div")
      span(:span_invalid_medication,              :id        => "lblerrorMedicationOrderCode")

      select_list(:select_potency_units,          :id        => "PotencyUnit")
      checkbox(:check_substitutions_allowed,      :id        => "SubstitutionsAllowed")
      text_field(:textfield_no_of_refills,        :id        => "Number")
      select_list(:select_frequency_and_timing,   :id        => "TimeAndFrequency")
      text_field(:textfield_dispense_amount,      :id        => "DispenseAmount")
      text_field(:textfield_dispense_units,       :id        => "DispenseUnits")
      text_field(:textfield_entry_date,           :id        => "Dateofentry")
      select_list(:select_status,                 :id        => "Status")

      button(:button_place_medication_order,      :id        => "lnkCreateMedicationOrder-button")
      button(:button_cancel_medication,           :id        => "lnkCancelMedicationOrder-button")

      # previous order for patients
      div(:div_medication_order,                  :id        => "medicationOrderTablediv")
      table(:table_medication_order,              :xpath     => "//div[@id='medicationOrderTablediv']/table")
      link(:link_view,                            :link_text => "View")
      link(:link_cancel,                          :link_text => "Cancel")
      link(:link_eprescribe,                      :link_text => "e-prescribe")

      # iframe
      div(:div_prescription_iframe,               :id        => "popup_small")
      button(:button_eprescribe,                  :id        => "lnkInteractionMsg-button")
      button(:button_handwritten,                 :id        => "ActionButton1-button")
      button(:button_cancel_medication,           :id        => "ActionButton2-button")
      link(:link_close_prescription_iframe,       :xpath     => "//div[@id='PopUpDivMaster']/a")
      div(:div_eprescribe, 						  :xpath => "//div[@id='popup_small']/div[2]/div[@class='btn_container']/div[1]/div[1]/div[1]")

      # description                : creates a medication order
      # Author                     : Chandra sekaran
      # Arguments                  :
      #  str_medication_type       : type of medication order - hand written or e-prescribed
      #  str_medication_order_node : root node of test data
      #
      def create_medication_order(str_medication_type, str_medication_order_node = "medication_order_data1")
        begin
          #wait_for_loading
          wait_for_object(select_pharmacy_element, "Failure in finding pharmacy select tag")
          hash_medication_order = set_scenario_based_datafile(MEDICATION_ORDER)

          str_priority = hash_medication_order[str_medication_order_node]["select_priority"]
          str_medication = hash_medication_order[str_medication_order_node]["textfield_medication"]
          str_master_medication = hash_medication_order[str_medication_order_node]["textfield_master_medication"]
          str_frequency = hash_medication_order[str_medication_order_node]["select_frequency_and_timing"]
          num_dispense_amount = hash_medication_order[str_medication_order_node]["textfield_dispense_amount"]
          str_pharmacy = hash_medication_order[str_medication_order_node]["select_pharmacy"]
          #str_ordered_by = hash_medication_order[str_medication_order_node]["select_medication_ordered_by"]
          #str_medication_notes = hash_medication_order[str_medication_order_node]["textarea_medication_notes"]
          #str_potency_units = hash_medication_order[str_medication_order_node]["select_potency_units"]
          #num_no_of_refills = hash_medication_order[str_medication_order_node]["textfield_no_of_refills"]
          #str_dispense_units = hash_medication_order[str_medication_order_node]["textfield_dispense_units"]

          select_pharmacy_element.when_visible.select(str_pharmacy)
          #self.textarea_medication_notes = str_medication_notes
          select_priority_element.select(str_priority)
          select_medication_ordered_by_element.when_visible.select($str_ep_name)

          if str_medication_type.downcase == "hand written medication order" || str_medication_type.downcase == "e-prescribed medication order" || str_medication_type.downcase == "another e-prescribed medication order" || str_medication_type.downcase == "medication order with controlled substance"
            self.textfield_medication = str_medication
            wait_for_object(div_medication_ajax_element)
            textfield_medication_element.focus
            textfield_medication_element.send_keys(:arrow_down) rescue Exception
            textfield_medication_element.send_keys(:tab)
          elsif str_medication_type.downcase == "hand written medication order from master list" || str_medication_type.downcase == "e-prescribed medication order from master list"
            self.textfield_master_medication = str_master_medication
            wait_for_object(div_master_medication_ajax_element)
            textfield_master_medication_element.focus
            textfield_master_medication_element.send_keys(:tab)
          else
            raise "Invalid medication type : #{str_medication_type}"
          end

          select_frequency_and_timing_element.when_visible.select(str_frequency)
          self.textfield_dispense_amount = num_dispense_amount
          #select_potency_units_element.when_visible.select(str_potency_units)
          #self.textfield_no_of_refills = num_no_of_refills
          #self.textfield_dispense_units = str_dispense_units

          wait_for_object(button_place_medication_order_element, "Failure in finding 'Place Order' button of medication order")
          3.times { button_place_medication_order_element.send_keys(:arrow_down) } rescue Exception
          click_on(button_place_medication_order_element)

          if span_invalid_medication_element.exists?
            raise "Validation error : #{span_invalid_medication_element.text}" if span_invalid_medication_element.visible?
          end

          wait_for_object(div_prescription_iframe_element, "Failure in finding prescription type iframe")

          if str_medication_type.downcase.include?("hand written")
            click_on(button_handwritten_element)
          elsif str_medication_type.downcase.include?("e-prescribed")
            click_on(button_eprescribe_element)
          elsif str_medication_type.downcase == "medication order with controlled substance"
            raise "Popup does not consist controlled drug warning" if !is_text_present(self, "Controlled drugs cannot be e-prescribed.")
            raise "E-prescribe button is enabled for 'medication order with controlled substance'" if !div_eprescribe_element.class_name.include?("disabled")
            click_on(button_handwritten_element)
          else
            raise "Invalid medication type : #{str_medication_type}"
          end

          raise "Could not find 'Medication Order created successfully' message" if !is_text_present(self, "Medication Order created successfully")
          $log.success("Medication order created successfully")
          $world.puts("Test data : #{hash_medication_order[str_medication_order_node].to_s}, select_medication_ordered_by => #{$str_ep_name}")
        rescue Exception => ex
          $log.error("Error while creating medication order : #{ex}")
          exit
        end
      end
    end

  end
end