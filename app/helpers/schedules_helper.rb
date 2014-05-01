require 'nokogiri'
require 'open-uri'
require_relative "course_scheduler/course_scheduler"

module SchedulesHelper

  include CourseScheduler

  VALID_COURSE_CODE_REGEX = /\A[a-zA-Z]{3}\d{4}\z/
  def valid_course_code? code
    code =~ VALID_COURSE_CODE_REGEX
  end

  def get_course_info(course_code, semester)
    course_html = get_course_html(course_code, semester).to_s
    course_data = extract_table_data(course_html, semester)

    return nil if course_data.nil?

    course_title = extract_course_title(course_html)
    {course_code => {:title => course_title, :activities => course_data}}
  end

  private

    def extract_course_title html
      regex = /[A-Z]{3}\d{4} - (.)*[A-Z]/
      html.to_s[regex].split(" - ")[1].titleize
    end


    def extract_table_data(html_in, semester)
      html = Nokogiri::HTML(html_in)
      html = html.at_css("div#" + semester)

      return nil unless html

      html = Nokogiri::HTML(html.to_s)

      sections = html.xpath('//table/tr/td[@class = "Section"]').collect{|elem| elem.inner_html}
      activities = html.xpath('//table/tr/td[@class = "Activity"]').collect{|elem| elem.inner_html}
      days = html.xpath('//table/tr/td[@class = "Day"]').collect{|elem| elem.inner_html}

      active_session = sections.first
      class_content = []
       for i in 0..sections.count - 1
         active_session = sections[i] unless sections[i].to_s.length == 1
         active_activity = activities[i].split
         active_day = days[i].split

         class_content.push( {:section => active_session.split[1],
                              :activity_name => active_activity[0..-2].join(" "),
                              :activity_num => active_activity.last,
                              :day => active_day[0],
                              :start_time => active_day[1],
                              :end_time => active_day[3]
                             }
                           )
       end
      class_content
    end

    def get_course_html(course_code, semester)
      Nokogiri::HTML(open(get_course_url(course_code, semester), {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
    end

    def get_course_url(course_code, semester)
      url = "https://web30.uottawa.ca/v3/SITS/timetable/Course.aspx?code=#{course_code}&session=#{semester}"
      puts "SCRAPING URL: " + url
      url
    end

end
