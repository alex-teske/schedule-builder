class SchedulesController < ApplicationController

  def add_course()

    session[:cart] ||= Array.new
    course_code = params[:course_code]

    if not valid_course_code?(course_code)
      flash[:error] = "Invalid course code"
    elsif session[:cart].include? course_code
      flash[:error] = "This course is already included"
    elsif session[:cart].length >= 9
      flash[:error] = "No more than 9 courses are allowed"
    else
      session[:cart].push(course_code)
    end

    redirect_to action: 'show_cart'
  end

  def confirmation_screen
    @semester = params[:semester]
    @course_codes = session[:cart]
    @course_info = Hash.new

    @course_codes.each do |code|
      course_info = get_course_info(code, @semester)
      @course_info[code] = course_info
    end
    session[:course_info] = @course_info
  end

  def generate_schedule

    courses = session[:course_info]
    @info = Array.new

    courses.values.each do |course|
      next if course.nil?
      course.each do |course_code, course_info|
        course_groups = {}
        course_info[:activities].each do |activity|
          course_groups[activity[:section]] ||= Course.new(course_code, course_info[:title], activity[:section] )
          course_groups[activity[:section]].add_activity(activity)
        end
        @info += [course_groups]
      end
    end

    CourseScheduler::set_courses(@info)
    @potential_schedules = CourseScheduler.get_course_options
  end

  def show_cart
    @schedule_builder = Schedule.new
    @schedule_cart = session[:cart]
  end

  def reset
    reset_session
    redirect_to action: 'show_cart'
  end

end
