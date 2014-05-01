class CourseSelection
  attr_accessor :course_code, :course_title, :group
  attr_reader :activities

  def initialize()
    @activities = Hash.new
  end

  def add_activity activity
    @activities[activity[:activity_name]] ||= Array.new
    @activities[activity[:activity_name]].push(activity)
  end


end