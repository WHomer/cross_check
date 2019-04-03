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


  def percentage_home_wins
    home_wins = 0
    @games.each do |row|
      home_wins += 1 if row["outcome"].include?("home win")
    end
    (home_wins / @games.count.to_f).round(2)
  end

  def biggest_blowout
    # Highest difference between winner and loser
    game = @games.max_by do |row|
      (row["away_goals"].to_i - row["home_goals"].to_i).abs
    end
    (game["away_goals"].to_i - game["home_goals"].to_i).abs
  end
end
