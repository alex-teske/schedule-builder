require_relative 'course_scheduler/course_template'
require_relative 'course_scheduler/schedule'
require_relative 'course_scheduler/schedule_bucket'
require_relative 'course_scheduler/schedule_ranker'


module CourseScheduler
  def self.set_courses(courses)
    @course_templates = Array.new

    courses.each do |course|
      course_template = Array.new
      course.keys.each do |group|
        templates = CourseTemplate.new(course[group])
        course_template.push(templates)
      end
      @course_templates += [course_template]
    end

  end

  def self.get_course_options

    all_schedules = generate_all_schedules
    valid_schedules = remove_invalid_schedules(all_schedules)
    bucketized_schedules = bucketize_schedules(valid_schedules)
    ScheduleRanker.rank_schedules(bucketized_schedules)

  end

private

  def self.generate_all_schedules

    course_options = Array.new

    @course_templates.each do |course|
      this_course_options = Array.new
      course.each do |template|
        course_selections = template.get_course_options
        this_course_options += course_selections
      end
      course_options.push(this_course_options)
    end


    schedule_options = Array.new
    course_options.each do |options|
      schedule_options.push(options.length)
    end

    all_combinations = get_combinations(schedule_options)


    schedules = Array.new
    all_combinations.each do |combination|
      schedule = Schedule.new

      courses = Array.new
      for i in 0..(combination.length-1)
        courses.push(course_options[i][combination[i]])
      end
      schedule.set_courses(courses)
      schedules.push(schedule)
    end

    schedules
  end

  def self.remove_invalid_schedules(schedules)
    valid_schedules = Array.new

    schedules.each do |schedule|
      valid_schedules.push(schedule) if schedule.valid?
    end

    valid_schedules
  end

  def self.bucketize_schedules(schedules)

    buckets = Array.new

    schedules.each do |schedule|
      found_bucket = false
      buckets.each do |bucket|
        if bucket.belongs_to?(schedule)
          bucket.schedules.push(schedule)
          found_bucket = true
        end
      end

      unless found_bucket
        bucket = ScheduleBucket.new
        bucket.schedules.push(schedule)
        buckets.push(bucket)
      end

    end

    buckets

  end
end
