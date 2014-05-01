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
end