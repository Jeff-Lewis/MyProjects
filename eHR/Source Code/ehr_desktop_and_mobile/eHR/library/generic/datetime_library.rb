=begin
*Name           : DateTimeLibrary
*Description    : module that define methods for all datetime related manipulations
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

module EHR
  module DateTimeLibrary

    # Description      : returns the current system time (datetime format)
    # Author           : Chandra sekaran
    #
    def get_current_datetime
      begin
        Time.now
      rescue Exception => ex
        $log.error("Error in getting current time : #{ex}")
        exit
      end
    end

    # Description     : returns the formatted system time (datetime format)
    # Author          : Chandra sekaran
    # Arguments       :
    #   date_time     : datetime value that has to be formatted
    #
    def get_formatted_datetime(date_time)
      begin
        date_time.strftime(DATETIME_FORMAT)
      rescue Exception => ex
        $log.error("Error in getting formatted time : #{ex}")
        #exit
      end
    end

    # Description     : returns the difference between two dates in Hours:Minutes:Seconds string
    # Author          : Chandra sekaran
    # Arguments       :
    #   start_date    : datetime value for start time
    #   end_date      : datetime value for end time
    #
    def get_datetime_diff(start_time, end_time)
      begin
        num_difference = end_time.to_i - start_time.to_i
        num_seconds    =  num_difference % 60                   # get seconds
        num_difference = (num_difference - num_seconds) / 60
        num_minutes    =  num_difference % 60                   # get minutes
        num_difference = (num_difference - num_minutes) / 60
        num_hours      =  num_difference % 24                   # get hours
        num_difference = (num_difference - num_hours)   / 24
        num_days       =  num_difference % 7                    # get days
        # num_weeks      = (num_difference - num_days)    /  7

        if num_days > 0
          return "#{num_days}:#{num_hours}:#{num_minutes}:#{num_seconds}"
        else
          return "#{num_hours}:#{num_minutes}:#{num_seconds}"
        end
      rescue Exception => ex
        $log.error("Error in getting datetime difference : #{ex}")
        #exit
      end
    end

  end
end