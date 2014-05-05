require_relative "activity"

class Schedule

  attr_reader :courses, :activities

  def initialize (courses = [])
    @courses = Array.new
    @activities = Array.new
    set_courses(courses) unless courses.empty?
  end

  def set_courses courses

    courses.each do |course|
      add_course(course)
    end
    determine_validity
  end

  def valid?
    @valid
  end

  def ==(other)
    my_activities = @activities.dup
    other_activities = other.activities.dup

    my_comparison = Array.new
    other_comparison = Array.new


    return false if my_activities.length != other_activities.length

    comparison_criterion = [:start_time, :end_time, :day, :activity_name, :course_id]
    for i in 0..my_activities.length-1
      my_activity = Hash.new
      other_activity = Hash.new

      comparison_criterion.each do |criteria|
        my_activity[criteria] = my_activities[i].send(criteria)
        other_activity[criteria] = other_activities[i].send(criteria)
      end
      my_comparison.push(my_activity)
      other_comparison.push(other_activity)
    end

    my_comparison == other_comparison
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
    @courses.last[:activity_groups] = Array.new

    course.activities.each do |activity_type|
      activity_type[1].each do |act|
        activity = Activity.new
        activity.set_info(@courses.count, act)
        @activities.push(activity)
        @courses.last[:activity_groups].push([act[:activity_name], act[:activity_num]]) unless act[:activity_name].to_s == "Lecture"
      end
    end
  end


  def determine_validity
    @valid = true

    for i in 0..@activities.count - 1
      for j in i+1..@activities.count-1
        @valid = false if @activities[i].overlaps_with?(@activities[j])
      end
    end
  end

end