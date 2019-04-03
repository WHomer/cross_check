module Game

  def highest_total_score
    # Highest sum of the winning and losing teams' scores
    result = @games.max_by{|row| row["away_goals"].to_i + row["home_goals"].to_i}
    result["away_goals"].to_i + result["home_goals"].to_i
  end

  def lowest_total_score
    result = @games.min_by{|row| row["away_goals"].to_i + row["home_goals"].to_i}
    result["away_goals"].to_i + result["home_goals"].to_i
  end

  def biggest_blowout
    # Highest difference between winner and loser
    game = @games.max_by do |row|
      (row["away_goals"].to_i - row["home_goals"].to_i).abs
    end
    (game["away_goals"].to_i - game["home_goals"].to_i).abs
  end

  def percentage_visitor_wins
    away_team_wins = @games.find_all do |game|
      game["away_goals"].to_i > game["home_goals"].to_i
    end
    (away_team_wins.count.to_f / @games.count).round(2)
  end

end
