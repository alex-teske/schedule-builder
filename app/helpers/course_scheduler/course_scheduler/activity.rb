class Activity
  attr_accessor :start_time, :end_time, :day, :section, :activity_name, :activity_num, :course_id

  def set_info course_id, activity_info
    @course_id = course_id
    @section = activity_info[:section]
    @activity_num = activity_info[:activity_num]
    @activity_name = activity_info[:activity_name]

    @day = activity_info[:day]

    start_hour = activity_info[:start_time].split(":")[0].to_i
    start_minute = activity_info[:start_time].split(":")[1].to_i
    end_hour = activity_info[:end_time].split(":")[0].to_i
    end_minute = activity_info[:end_time].split(":")[1].to_i

    @start_time = DateTime.now.change({:hour => start_hour, :min => start_minute})
    @end_time = DateTime.now.change({:hour => end_hour, :min => end_minute})
  end

  def length
    ((@end_time - @start_time) * 24).to_f
  end

  def overlaps_with? other
    return false unless @day == other.day

    condition_1 = @start_time < other.end_time
    condition_2 = @end_time > other.start_time

    condition_1 and condition_2
  end
end