=begin
  *Name               : Reconcile
  *Description        : module that defines method to merge or revert Reconcile data in health status screen
  *Author             : Chandra sekaran
  *Creation Date      : 11/13/2014
  *Modification Date  :
=end

module EHR
  module HealthStatusTab
    module Reconcile

      include PageObject
      include PageUtils

      #button(:button_reconcile_all,                       :id       => "ActionButton2-button")
      div(:div_reconcile_iframe,                          :id       => "felix-widget-dialog-PopUpDivMaster-datadiv")
      form(:form_reconcile_all,                           :id       => "ReconcileAll")

      # New - Source: Transition of Care
      # Problems
      div(:div_new_reconcile_problem,                     :id       => "divReconcileProblem")
      table(:table_new_reconcile_problem,                 :id       => "tblReconcileProblem")

      # Allergy
      div(:div_new_reconcile_allergy,                     :id       => "divReconcileAllergy")
      table(:table_new_reconcile_allergy,                 :id       => "tblReconcileAllergy")

      # Medication
      div(:div_new_reconcile_medication,                  :id       => "divReconcileMedication")
      table(:table_new_reconcile_medication,              :id       => "tblReconcileMedication")

      button(:button_merge,                               :id       => "btnMergeAll")
      button(:button_revert,                              :id       => "btnRevert")

      # Current List source: eHR
      # Problems
      div(:div_currentlist_reconcile_problem,             :id       => "actProblemList")
      table(:table_currentlist_reconcile_problem,         :id       => "tblActiveProblem")

      # Allergy
      div(:div_currentlist_reconcile_allergy,             :id       => "actAllergyList")
      table(:table_currentlist_reconcile_allergy,         :id       => "tblActiveAllergy")

      # Medication
      div(:div_currentlist_reconcile_medication,          :id       => "actMedicationList")
      table(:table_currentlist_reconcile_medication,      :id       => "tblActiveMedication")

      button(:button_reconcile,                           :id       => "lnkReconcileAll-button")
      button(:button_close_reconcile,                     :id       => "lnkCloseCreateVisit-button")
      link(:link_close_reconcile,                         :xpath    => "//div[@id='PopUpDivMaster']/a")

      # description          : merges source (problem/allergy/medication) into reconcile in health status page
      # Author               : Chandra sekaran
      # Arguments            :
      #   str_section        : section type (problem/allergy/medication)
      #
      def merge(str_section)
        begin
          wait_for_loading
          ##wait_for_object(div_reconcile_iframe_element, "Failure in finding Reconcile iframe")
          case str_section.downcase
            when /problem/
              div_container = div_new_reconcile_problem_element
              table_container = table_new_reconcile_problem_element
              position = @hash_new_reconcile_problem_table[:SELECT]
            when /allergy/
              div_container = div_new_reconcile_allergy_element
              table_container = table_new_reconcile_allergy_element
              position = @hash_new_reconcile_allergy_table[:SELECT]
            when /medication/
              div_container = div_new_reconcile_medication_element
              table_container = table_new_reconcile_medication_element
              position = @hash_new_reconcile_medication_table[:SELECT]
            else
              raise "Invalid source type : #{str_section}"
          end

          wait_for_object(div_container, "Failure in finding #{str_section} div under reconcile")
          div_container.scroll_into_view rescue Exception
          3.times { div_container.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"

          table_container.table_elements(:xpath => "./tbody/tr").each_with_index do |row, index|
            row.checkbox_element(:xpath => "./td[#{position}]/input[1]").click if index > 0
          end

          click_on(button_merge_element)
          button_reconcile_element.scroll_into_view rescue Exception
          click_on(button_reconcile_element)
        rescue Exception => ex
          $log.error("Error while merging #{str_section} in reconcile : #{ex}")
          exit
        end
      end

      # description          : verifies source (problem/allergy/medication) in health status page
      # Author               : Chandra sekaran
      # Arguments            :
      #   str_section        : section type (problem/allergy/medication)
      #
      def verify_reconcile(str_section)
        begin
          wait_for_loading
          case str_section
            when /medication/
              wait_for_object(div_medication_div_element, "Failure in finding Medication div in Health status page")
              div_medication_div_element.scroll_into_view rescue Exception
              3.times { div_medication_div_element.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"
              num_count = 0
              table_medication_details_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
                str_medication = row.cell_element(:xpath => "./td[#{@hash_medication_list_table[:MEDICATION]}]").text.strip
                num_count += 1 if $arr_medication_list_name.include? str_medication
              end

              raise "Mismatch in number of medications in health status page" if num_count != $arr_medication_list_name.size
              $log.success("Successfully verified medication(s) in the Health status page")
            else
               raise "Invalid section under health status page : #{str_section}"
          end
        rescue Exception => ex
          $log.error("Error in verifying reconcile for #{str_section} :#{ex}")
          exit
        end
      end

    end
  end
end
