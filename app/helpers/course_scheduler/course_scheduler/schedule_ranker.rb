class ScheduleRanker

  def self.set_ranking_parameters params = {}
    @objectives = Hash.new
    @objectives["Days of class"] = params["Days of class"] || 0
    @objectives["Hours of breaks"] = params["Hours of breaks"] || 0
  end

  def self.rank_schedules schedules
    set_ranking_parameters if @objectives.nil?
    schedule_evaluations = evaluate_schedules(schedules)
    sort_schedules(schedules, schedule_evaluations)
  end

private
  def self.evaluate_schedules schedules

    schedule_evaluation = Array.new
    schedules.each do |schedule|
      evaluation = Array.new
      @objectives.each do |objective, target|
        objective_function_value = evaluate_objective_function(schedule.statistics[objective], target)
        evaluation.push(objective_function_value)
      end
      schedule_evaluation.push(evaluation)
    end
    schedule_evaluation
  end

  def self.evaluate_objective_function(target, value)
    (target-value).abs
  end

  def self.sort_schedules(schedules, evaluation)
    evaluation.each_with_index {|item, index| item.push(index)}
    evaluation.sort!
    evaluation.collect {|item| schedules[item.last]}
  end
end