require_relative 'helpers'
require_relative 'course_selection'

class CourseTemplate
  attr_accessor :course_code, :course_title, :group
  attr_reader :activities

  def initialize(course_info)
    @course_code = course_info.course_code
    @course_title = course_info.course_title
    @group = course_info.group
    @activities = Hash.new

    section_activities = course_info.activities

    @lectures = section_activities["Lecture"]

    section_activities.each do |activity|
      add_activity(activity)
    end
  end

  def add_activity(activity)
    @activities[activity.first] ||= activity[1]
  end

  def get_course_options

    activity_options = Array.new
    @activities.each do |activity_type, activities |
      if activity_type == "Lecture"
        activity_options.push(1)
      else
        activity_options.push(activities.length)
      end
    end

    activity_combinations = get_combinations(activity_options)

    courses = Array.new
    activity_combinations.each do |combination|
      course = CourseSelection.new
      course.course_code = @course_code
      course.course_title = @course_title
      course.group = @group

      for i in 0..(combination.length-1)
        course_type = @activities.keys[i]
        if course_type == "Lecture"
          @activities[course_type].each do |lecture|
            course.add_activity(lecture)
          end
        else
          course.add_activity(@activities[course_type][combination[i]])
        end
      end

      courses.push(course)
    end
    courses
  end
end