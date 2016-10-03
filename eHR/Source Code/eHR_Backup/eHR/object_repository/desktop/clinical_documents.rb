=begin
  *Name             : ClinicalDocuments
  *Description      : contains all objects and methods in Clinical documents page
  *Author           : Chandra sekaran
  *Creation Date    : 17/11/2014
  *Modification Date:
=end

module EHR
  class ClinicalDocuments
    include PageObject
    include PageUtils
    include Pagination

    form(:form_clinical_document,  :id        => "patientdocument")
    div(:div_document_list,        :id        => "patient_doc_container_div")
    table(:table_document_list,    :xpath     => "//div[@id='patient_doc_container_div']/table")
    label(:label_view,             :link_text => "View")
    label(:label_delete,           :link_text => "Delete")

    # description          : invoked automatically when page class object is created
    # Author               : Chandra sekaran
    #
    def initialize_page
      wait_for_page_load
      wait_for_object(form_clinical_document_element)
      hash_creation
    end

    # description          : creates hash for indexing table data
    # Author               : Chandra sekaran
    #
    def hash_creation
      @hash_clinical_documents = {
          :TASK => 1,
          :PATIENT_NAME => 2,
          :DATE_OF_BIRTH => 3,
          :RECEIVED_DATE => 4,
          :SENDING_SYSTEM => 5,
          :LAST_VIEWED_DATE => 6
      }
    end

    # Description           : Method to view received CCD document in a window from clinical documents page
    # Author                : Chandra sekaran
    # Arguments             :
    #   str_patient_name    : Name of the Patient
    #
    def view_document(str_patient_name)
      begin
        wait_for_object(div_document_list_element, "Failure in finding Clinical document list table")
        if is_record_exists(div_document_list_element, @hash_clinical_documents[:PATIENT_NAME], str_patient_name)
          iterate = true
          while(iterate)
            # get all tr tags (rows) of table using xpath
            table_document_list.table_elements(:xpath => "./tbody/tr").each do |row|
              if row.cell_element(:xpath => "./td[#{@hash_clinical_documents[:PATIENT_NAME]}]").text.strip == str_patient_name
                obj_image_task = row.cell_element(:xpath => "./td[#{@hash_clinical_documents[:TASK]}]").image_element(:xpath => "./div/img")
                obj_image_task.focus
                obj_image_task.fire_event("onmouseover")
                click_on(label_view_element)
                iterate = false
                break
              end
            end
            iterate = click_next(div_document_list_element) if iterate != false
          end
        else
          raise "No such a document with patient name : #{str_patient_name}"
        end
        $log.success("The patient '#{str_patient_name}' Clinical document viewed successfully")
      rescue Exception => ex
        $log.error("Error while viewing the Clinical documents : #{ex}")
        exit
      end
    end

  end
end