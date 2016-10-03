=begin
*Name           : HL7_Utils
*Description    : class that defines methods for HL7 messaging
*Author         : Chandra sekaran
*Creation Date  : 08/12/2014
*Updation Date  :
=end

module EHR
  class HL7_Utils
    include PageUtils
    include DateTimeLibrary

    # Description                   : invoked automatically when a class object is created
    # Author                        : Chandra sekaran
    # Arguments                     :
    #   str_lab_order_range         : report range for Lab order
    #   str_result_type             : Lab order type
    #   str_lab_result_report_range : report range for Lab result
    #
    def initialize(str_lab_order_range, str_result_type, str_lab_result_report_range)
      @str_lab_order_date = get_date(str_lab_order_range)
      @specimen_collection_date = @str_lab_order_date      # as mentioned in sample HL7 files specimen collection date should be preferably same as order date
      @str_result_type = str_result_type
      @str_test_report_date = get_date(str_lab_result_report_range)
      create_hl7_template_files_hash
    end

    # Description         : creates hash for HL7 message template files
    # Author              : Chandra sekaran
    #
    def create_hl7_template_files_hash
      @hash_hl7_message_template_files = {
          :LAB_ORDER_WITH_MULTIPLE_RESULTS => "lab_order_with_multiple_results.txt",
          :NEGATIVE_LAB_ORDER => "negative_lab_order_and_result.txt",
          :NOT_POSITIVE_NEGATIVE_NUMERIC_LAB_ORDER => "not_positive_negative_numeric_lab_order_and_result.txt",
          :NOT_POSITIVE_NEGATIVE_NUMERIC_LAB_ORDER1 => "not_positive_negative_numeric_lab_order_and_result1.txt",
          :NUMERIC_LAB_ORDER => "numeric_lab_order_and_result.txt",
          :POSITIVE_LAB_ORDER => "positive_lab_order_and_result.txt"
      }
    end

    # Description         : reads HL7 template file content
    # Author              : Chandra sekaran
    #
    def load_hl7_message_template
      begin
        @str_template_file_name = if @str_result_type.downcase.include? "multiple"
                                    @hash_hl7_message_template_files[:LAB_ORDER_WITH_MULTIPLE_RESULTS]
                                  elsif @str_result_type.downcase.include? "negative"
                                    @hash_hl7_message_template_files[:NEGATIVE_LAB_ORDER]
                                  elsif (@str_result_type.downcase.include? "not positive negative numeric") || (@str_result_type.downcase.include? "inconclusive")
                                    @hash_hl7_message_template_files[:NOT_POSITIVE_NEGATIVE_NUMERIC_LAB_ORDER]
                                  elsif @str_result_type.downcase.include? "numeric"
                                    @hash_hl7_message_template_files[:NUMERIC_LAB_ORDER]
                                  elsif @str_result_type.downcase.include? "positive"
                                    @hash_hl7_message_template_files[:POSITIVE_LAB_ORDER]
                                  else
                                    raise "Invalid Lab Order type : #{@str_result_type}"
                                  end
        @str_hl7_msg_template = File.read "#{File.expand_path('library/hl7_messages')}/templates/#{@str_template_file_name}"
      rescue Exception => ex
        $log.error("Error while loading HL7 message template for #{@str_result_type}:#{ex} ")
        exit
      end
    end

    # Description         : creates a new HL7 message file
    # Author              : Chandra sekaran
    #
    def create_hl7_message_file
      begin
        # replace the template content with actual data

        $str_patient_id = create_patient_id
        str_hl7_message = @str_hl7_msg_template.gsub("CUST_PAT_ID", $str_patient_id)
        str_hl7_message = str_hl7_message.gsub("CUST_EP_NPI", ($str_ep.downcase.include? "stage1 ep")? STAGE1_EP_NPI : STAGE2_EP_NPI)
        str_hl7_message = str_hl7_message.gsub("CUST_EP_LAST_NAME", ($str_ep.downcase.include? "stage1 ep")? STAGE1_EP_LAST_NAME : STAGE2_EP_LAST_NAME)
        str_hl7_message = str_hl7_message.gsub("CUST_EP_FIRST_NAME", ($str_ep.downcase.include? "stage1 ep")? STAGE1_EP_FIRST_NAME : STAGE2_EP_FIRST_NAME)
        str_hl7_message = str_hl7_message.gsub("CUST_ORDER_DATE", @str_lab_order_date)
        str_hl7_message = str_hl7_message.gsub("CUST_SPECIMEN_COLLECTION_DATE", @specimen_collection_date)
        str_hl7_message = str_hl7_message.gsub("CUST_TEST_REPORT_DATE", @str_test_report_date)

        str_tag = ""
        $scenario_tags.each do |tag|           # get current scenario tag name
          str_tag = tag if tag.include? "@tc_"
        end
        str_file_name = @str_template_file_name.split(".").first
        str_file_name = "#{str_tag}_#{str_file_name}_#{get_formatted_datetime(Time.now)}.txt"

        # create a new HL7 message file having str_hl7_message variable content
        create_directory("#{File.expand_path('library')}/hl7_messages/temp")   # creates a directory temp for storing HL7 message files
        @str_hl7_file_path = "#{File.expand_path('library')}/hl7_messages/temp/#{str_file_name}"
        File.open(@str_hl7_file_path, "w") do |file|
          file.write(str_hl7_message)
        end
        $str_hl7_file_name = @str_hl7_file_path.split("/").last
      rescue Exception => ex
        $log.error("Error while creating HL7 message for #{@str_result_type}:#{ex} ")
        exit
      end

    end

    # Description         : executes command for sending HL7 message
    # Author              : Chandra sekaran
    #
    def send_message
      begin
        # execute the java command for sending HL7 message using CMDHL7_v0.7.jar file
        str_jar_file_path = File.expand_path("library/app_utils/HL7Sender.jar")

        str_command = "java -jar \"#{str_jar_file_path}\" --host=#{HL7_SERVER_IP} --port=#{HL7_SERVER_PORT} --file=\"#{@str_hl7_file_path}\""

        #args = []
        #args << "java"
        #args << "-jar"
        #args << str_jar_file_path
        #args << "--host=#{HL7_SERVER_IP}"
        #args << "--port=#{HL7_SERVER_PORT}"
        #args << "--file=\"#{@str_hl7_file_path}\""
        #str_status = system(*args)
        $log.success("HL7 message response : ")
        execute_command(str_command)
      rescue Exception => ex
        $log.error("Error while sending HL7 message #{@str_result_type}:#{ex} ")
        exit
      end
    end

    # Description         : sends HL7 message
    # Author              : Chandra sekaran
    # Return argument     : a boolean value that denotes whether the HL7 message has been successfully sent and recieved acknowledgement ot not
    #
    def send_hl7_message
      load_hl7_message_template
      create_hl7_message_file
      bool_status = send_message
      relocate_temp_files
      return bool_status
    end

    # Description         : creates timestamp value based on report range
    # Author              : Chandra sekaran
    # Return argument     : returns a datetime object
    #
    def get_date(str_report_range)
      obj_date = pacific_time_calculation
       if str_report_range.downcase.include? "within"
         return (obj_date - 1.days).strftime("%Y%m%d%H%M%S")
       elsif str_report_range.downcase.include? "outside"
         return (obj_date + 1.days).strftime("%Y%m%d%H%M%S")
       else
         raise "Invalid report range : #{str_report_range}"
       end
    end

    # Description         : creates a new patient ID
    # Author              : Chandra sekaran
    #
    def create_patient_id
      obj_date = pacific_time_calculation
      "A" + obj_date.strftime("%H%M%S").to_s
    end

    # Description         : moves the HL7 message file from temp directory to current test report directory
    # Author              : Chandra sekaran
    #
    def relocate_temp_files
      begin
        str_imgdir_path = "#{$current_log_dir}/screenshot"
        unless File.directory?(str_imgdir_path)   # creates a new directory
          FileUtils.mkdir_p(str_imgdir_path)
        end
        FileUtils.mv(@str_hl7_file_path, "#{$current_log_dir}/screenshot")
      rescue Exception => ex
        $log.error("Error while relocating HL7 message #{@str_result_type}:#{ex} ")
        exit
      end
    end

  end
end