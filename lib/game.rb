module Game

  def highest_total_score
    # Highest sum of the winning and losing teams' scores
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
    # Highest difference between winner and loser
    game = @games.max_by do |row|
      (row[:away_goals].to_i - row[:home_goals].to_i).abs
    end
    (game[:away_goals].to_i - game[:home_goals].to_i).abs
  end

  # Percentage of games that a visitor has won (rounded to the nearest 100th)
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

  # Average number of goals scored in a game across all seasons (rounded to the nearest 100th)
  def average_goals_per_game
    total_goals = @games.sum do |game|
      game[:home_goals] + game[:away_goals]
    end
    (total_goals.to_f / @games.count).round(2)
  end

  # Iteration 3
  # Description: Name of the team with the highest average number
  # of goals scored per game across all seasons.
  # Return Value: String
  def best_offense
    team_ids_hash = Hash.new
    @teams.each do |team|
      team_ids_hash[team[:team_name]] = {goals: 0, games: 0, average: 0}
    end

    @combine_data.each do |game|
      team_name = team_ids_hash[game[:team_name]]
      team_name[:goals] += game[:goals].to_i
      team_name[:games] += 1
      team_name[:average] = (team_name[:goals].to_f / team_name[:games]).round(2)
    end
    team_ids_hash.max_by { |team| team[1][:average] }[0]
  end

# Method: highest_scoring_home_team
# Description: Name of the team with the highest average score per game across all seasons when they are home.
# Return Value: String
end #module end
