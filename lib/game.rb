module Game

  def highest_total_score
    # Highest sum of the winning and losing teams' scores
    result = @games.max_by{|row| row[:away_goals] + row[:home_goals]}
    result[:away_goals] + result[:home_goals]
  end

end
