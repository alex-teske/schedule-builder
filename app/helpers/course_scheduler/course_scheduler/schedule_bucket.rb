class ScheduleBucket
  attr_accessor :schedules

  def initialize
    @schedules = Array.new
  end

  def belongs_to? schedule
    schedule == @schedules.first
  end

  def get_description
    description = Hash.new
    @schedules.each do |schedule|
      schedule.courses.each do |course|
        description[course[:course_code]] ||= Hash.new
        description[course[:course_code]][course[:group]] ||= Hash.new
        course[:activity_groups].each do |activity|
          description[course[:course_code]][course[:group]][activity[0]] ||= Array.new
          description[course[:course_code]][course[:group]][activity[0]].push(activity[1]).uniq!
        end
      end
    end
    description
  end

  def statistics
    @statistics ||= calculate_statistics
  end

private

  def calculate_statistics
    statistics = Hash.new

    #all courses in the bucket have the same statistics
    course = @schedules.first

    class_per_day = {}
    hours_of_class = 0
    hours_of_breaks = 0
    course.activities.each do |activity|
      class_per_day[activity.day] ||= Hash.new
      class_per_day[activity.day][:start_time] = [(class_per_day[activity.day][:start_time] || activity.start_time),activity.start_time].min
      class_per_day[activity.day][:end_time] = [(class_per_day[activity.day][:end_time] || activity.end_time),activity.end_time].max
      class_per_day[activity.day][:course_length] ||= 0
      class_per_day[activity.day][:course_length] += activity.length
      hours_of_class += activity.length
    end

    class_per_day.each do |day, hours|
      total_day_length = ((hours[:end_time] - hours[:start_time]) * 24)
      hours_of_breaks += total_day_length - hours[:course_length]
    end

    statistics["Days of class"] = class_per_day.keys.length
    statistics["Hours of class"] = hours_of_class
    statistics["Hours of breaks"] = hours_of_breaks

    statistics
  end

end