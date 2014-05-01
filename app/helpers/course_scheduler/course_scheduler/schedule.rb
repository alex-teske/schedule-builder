require_relative "Activity"

class Schedule

  attr_reader :courses, :activities, :statistics

  def initialize (courses = [])
    @courses = Array.new
    @activities = Array.new
    @statistics = Hash.new
    set_courses(courses) unless courses.empty?
  end

  def set_courses courses

    courses.each do |course|
      add_course(course)
    end
    initialize_courses
  end

  def valid?
    @valid
  end

  def get_class_at_time(day, hour, minute)
    time = DateTime.now.change({:hour => hour, :min => minute})
    requested_activity = nil
    @activities.each do |activity|
      if activity.day == day and (activity.start_time...activity.end_time).cover?(time)
        requested_activity = activity
        break
      end
    end

    requested_activity
  end

private

  def add_course course
    @courses.push({:course_title => course.course_title, :course_code => course.course_code, :group => course.group})

    course.activities.each do |activity_type|
      activity_type[1].each do |act|
        activity = Activity.new
        activity.set_info(@courses.count, act)
        @activities.push(activity)
      end

    end
  end

  def initialize_courses
    determine_validity
    calculate_statistics if @valid
  end

  def determine_validity
    @valid = true

    for i in 0..@activities.count - 1
      for j in i+1..@activities.count-1
        @valid = false if @activities[i].overlaps_with?(@activities[j])
      end
    end
  end

  def calculate_statistics
    days_of_class = {}
    @activities.each do |activity|
      days_of_class[activity.day] ||= 0
      days_of_class[activity.day] += activity.length
    end

    hours_of_class = 0

    days_of_class.values.each do |x|
      hours_of_class += x
    end

    @statistics["Days of class"] = days_of_class.keys.length
    @statistics["Hours of class"] = hours_of_class
  end

end