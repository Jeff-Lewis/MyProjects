module EHR
  class Holiday
    include PageUtils
    def initialize
    end

    # Description          : Function for Calculating Federal holiday list
    # Author               : Gomathi
    # Return argument      : arr_holidays
    #
    def federal_holiday_calculation
      begin
        object_date_time = pacific_time_calculation
        hash_holiday = $obj_yml.get_value("holiday_list")
        arr_holidays = []
        num_count = 30

        hash_holiday.each do |key, value|
          if value.include?("/")
            arr_day = value.split("/")
            object_holiday = Time.parse("#{object_date_time.strftime("%Y")}#{arr_day[0]}#{arr_day[1]}")
            if object_holiday.strftime("%A").downcase == "saturday"
              object_holiday = object_holiday - 1.days
            elsif object_holiday.strftime("%A").downcase == "sunday"
              object_holiday = object_holiday + 1.days
            end
          else
            arr_day = value.split(" ")
            case arr_day[3].downcase
              when "january"
                str_month = "01"
              when "february"
                str_month = "02"
              when "march"
                str_month = "03"
              when "april"
                str_month = "04"
              when "may"
                str_month = "05"
              when "june"
                str_month = "06"
              when "july"
                str_month = "07"
              when "august"
                str_month = "08"
              when "september"
                str_month = "09"
              when "october"
                str_month = "10"
              when "november"
                str_month = "11"
              when "december"
                str_month = "12"
              else
                raise "Invalid input : #{arr_day[3]}"
            end
            object_first_day_of_month = Time.parse("#{object_date_time.strftime("%Y")}#{str_month}01")

            case arr_day[1].downcase
              when "monday"
                num_day_count = 1
              when "tuesday"
                num_day_count = 2
              when "wednesday"
                num_day_count = 3
              when "thursday"
                num_day_count = 4
              when "friday"
                num_day_count = 5
              else
                raise "Invalid input : #{arr_day[1]}"
            end

            case arr_day[0].downcase
              when "first"
                num_additional_days = 0
              when "second"
                num_additional_days = 7
              when "third"
                num_additional_days = 14
              when "fourth"
                num_additional_days = 21
              when "last"
                num_count -= 1 until object_first_day_of_month.month == (object_first_day_of_month + num_count.days).month
              else
                raise "Invalid input : #{arr_day[0]}"
            end

            if arr_day[0].downcase != "last"
              object_first_day_of_month = object_first_day_of_month + 1.days while object_first_day_of_month.wday != num_day_count
              object_holiday = object_first_day_of_month + num_additional_days.days
            else
              object_last_day_of_month = object_first_day_of_month + num_count.days
              object_last_day_of_month = object_last_day_of_month - 1.days while object_last_day_of_month.wday != num_day_count
              object_holiday = object_last_day_of_month
            end
          end
          arr_holidays << object_holiday.strftime("%m/%d/%Y")
        end
        puts "The holiday list for the current year is #{arr_holidays}"
        arr_holidays
      rescue Exception => ex
        $log.error("Error while Calculating holiday : #{ex}")
        exit
      end
    end
  end
end
