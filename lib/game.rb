module Game

  def highest_total_score
    result = @games.max_by{|row| row[:away_goals].to_i + row[:home_goals].to_i}
    result[:away_goals].to_i + result[:home_goals].to_i
  end

  def lowest_total_score
    result = @games.min_by{|row| row[:away_goals].to_i + row[:home_goals].to_i}
    result[:away_goals].to_i + result[:home_goals].to_i
  end

  def percentage_home_wins
    home_wins = 0
    @games.each do |row|
      home_wins += 1 if row[:outcome].include?("home win")
    end
    (home_wins / @games.count.to_f).round(2)
  end

  def biggest_blowout
    game = @games.max_by do |row|
      (row[:away_goals].to_i - row[:home_goals].to_i).abs
    end
    (game[:away_goals].to_i - game[:home_goals].to_i).abs
  end

  def percentage_visitor_wins
    away_team_wins = @games.find_all do |game|
      game[:away_goals].to_i > game[:home_goals].to_i
    end
    (away_team_wins.count.to_f / @games.count).round(2)
  end

  def count_of_games_by_season
    season_games = {}
    games_by_season = @games.group_by { |game| game[:season] }
    games_by_season.each do |season, games|
      season_games[season.to_s] = games.count
    end
    season_games
  end

  def goals_per_game_by_season
    season_goals = Hash.new { |season, goals| season[goals] = [] }
    @games.each do |game|
      season_goals[game[:season].to_s] << (game[:home_goals] + game[:away_goals])
    end
    season_goals
  end

  def average_goals_by_season
    average_goals = {}
    goals_per_game_by_season.each do |season, goals|
      average_goals[season] = (goals.sum.to_f / goals.count).round(2)
    end
    average_goals
  end

  def average_goals_per_game
    total_goals = @games.sum do |game|
      game[:home_goals] + game[:away_goals]
    end
    (total_goals.to_f / @games.count).round(2)
  end

end 
