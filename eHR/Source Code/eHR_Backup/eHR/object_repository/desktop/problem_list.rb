=begin
  *Name               : ProblemList
  *Description        : class to add / edit the problem list in health status page
  *Author             : Chandra sekaran
  *Creation Date      : 10/27/2014
  *Modification Date  :
=end

module EHR
  module HealthStatusTab
    module ProblemList

      include PageObject
      include PageUtils
      include Pagination

      # Page Object details for create problem list
      span(:span_add_problem_list,                            :id        => "lnkCreateProblem")
      span(:span_none_known_problem_list,                     :id        => "ActionButton19")
      div(:div_problem_list_details,                          :id        => "problems_list_details_div")
      table(:table_problem_list,                              :xpath     => "//div[@id='problems_list_details_div']/table")
      link(:link_edit_problem,                                :link_text => "Edit")
      link(:link_delete_problem,                              :link_text => "Delete")
      link(:link_inactivate_problem,                          :link_text => "Inactivate")
      div(:div_problem_list,                                  :id        => "ProblemList")

      # Create problem iframe content
      form(:form_create_problem,                              :id        => "createproblemfrm")
      div(:div_create_problem,                                :id        => "newProbleDiv")
      checkbox(:check_exclude_from_eoe,                       :id        => "ExcludeProblemFromEOE")
      text_field(:textfield_problem,                          :id        => "ProblemCodeStr_TextBox")
      div(:div_problem_list_ajax,                             :xpath     => "//div[@id='ProblemCodeStr_container']/div")
      select_list(:select_status,                             :id        => "Status")
      text_field(:textfield_user_name,                        :id        => "UserName")
      text_field(:textfield_date,                             :id        => "ProblemEnteredOnStr")
      text_field(:textfield_diagnosed_date,                   :id        => "felix-widget-calendar-ProblemDiagnosedStr-input")
      text_area(:textarea_description,                        :id        => "Description")
      span(:span_save_and_add_problem,                        :id        => "createproblemactionpannel")
      span(:span_save_and_close_problem,                      :xpath     => "//form[@id='createproblemfrm']//div[@class='btn']/span[contains(@id,'ActionPanel')]")  #:id        => "ActionPanel2")
	    button(:button_save_and_close_problem,                  :value     => "Save/Close")
      span(:span_cancel_problem,                              :id        => "ActionPanel1")

      # Edit problem iframe content
      span(:span_save_and_close_edit_problem,                 :id        => "editProblemactionpannel")
      span(:span_cancel_edit_problem,                         :id        => "editProblemactionpannel1")

      link(:link_close_problem_iframe,                        :xpath     => "//div[@id='PopUpDivMaster']/a")

      # Description         : Method to Add the problem details in health status page
      # Author              : Chandra sekaran
      # Arguments           :
      #   str_problem_list  : string that denotes type of problem list
      #   str_problems_node : root node of problems test data
      # Return Argument     :
      #   str_problem       : problem name
      #
      def add_problem(str_problem_list, str_problems_node)
        begin
          if $scenario_tags.include?("@tc_753") || $scenario_tags.include?("@tc_6178")
            $num_test_data_count += 1
            str_problems_node = "problem_list_data#{$num_test_data_count}"
          end

          hash_problem = set_scenario_based_datafile("problem_list.yml")

          str_coded_problem = hash_problem[str_problems_node]["textfield_problem"]
          str_description = hash_problem[str_problems_node]["textarea_description"]
          str_uncoded_problem = hash_problem[str_problems_node]["textfield_uncoded_problem"]
          object_date_time = pacific_time_calculation
          wait_for_object(textfield_problem_element, "Failure in finding Problem test field")

          if str_problem_list.downcase == "coded problem list"
            self.textfield_problem = str_coded_problem
            wait_for_object(div_problem_list_ajax_element, "Failure in finding div for Problem name list")
            div_problem_list_ajax_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
              list_item.scroll_into_view rescue Exception
              if list_item.text.downcase.strip == str_coded_problem.downcase
                list_item.click
                break
              end
            end
            sleep 1
            #textfield_problem_element.send_keys(:arrow_down) rescue Exception
            #textfield_problem_element.send_keys(:tab)
            str_problem = str_coded_problem
          elsif str_problem_list.downcase == "uncoded problem list"
            self.textfield_problem = str_uncoded_problem
            wait_for_object(div_problem_list_ajax_element)
            sleep 1
            textfield_problem_element.send_keys(:tab)
            str_problem = str_uncoded_problem
            sleep 1
          else
            raise "Invalid input for str_problem_list : #{str_problem_list}"
          end
          @browser.find_element(:id, "felix-widget-calendar-ProblemDiagnosedStr-input").click
          @browser.find_element(:id, "felix-widget-calendar-ProblemDiagnosedStr-input").send_keys(object_date_time.strftime("0101%Y"))

          $world.puts("Test data : #{hash_problem[str_problems_node].to_s}, textfield_diagnosed_date => #{object_date_time.strftime("01/01/%Y")}")
          $log.success("Data population for create #{str_problem_list} done successfully")
          return str_problem
        rescue Exception => ex
          $log.error("Error while filling data for create #{str_problem_list} : #{ex}")
          exit
        end
      end

      # Description         : saves the problem details and closes the iframe
      # Author              : Chandra sekaran
      # Arguments           :
      #   str_problem_list  : string that denotes type of problem list
      #   str_problems_node : root node of problems test data
      # Return Argument     :
      #    str_problem      : problem name
      #
      def save_and_close_create_problem(str_problem_list, str_problems_node = "problem_list_data1")
        begin
          str_problem = add_problem(str_problem_list, str_problems_node)
          #click_on(span_save_and_close_problem_element)
          click_on(button_save_and_close_problem_element)
          return str_problem
        rescue Exception => ex
          $log.error("Error in save and close problem details :#{ex}")
          exit
        end
      end

      # Description         : saves the problem details and add multiple entries
      # Author              : Chandra sekaran
      # Arguments           :
      #   str_problem_list  : string that denotes type of problem list
      #   str_problems_node : root node of problems test data
      # Return Argument     :
      #    str_problem      : problem names
      #
      def save_and_add_create_problem(str_problem_list, str_problems_node = "problem_list_data1")
        begin
          str_problem = add_problem(str_problem_list, str_problems_node)
          click_on(span_save_and_add_problem_element)
          return str_problem
        rescue Exception => ex
          $log.error("Error in save and add more problem details :#{ex}")
          exit
        end
      end

    end
  end
end