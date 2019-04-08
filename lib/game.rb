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

  def goals_per_game_by_season
    # helper
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

  def games_played_in
    @games.find_all do |game|
      game[:away_team_id].to_s == :team_id || game[:home_team_id].to_s == :team_id
    end
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
    team_names_hash = Hash.new
    @teams.each do |team|
      team_names_hash[team[:team_name]] = {goals: 0, games: 0, average: 0}
    end

    @combine_data.each do |game|
      team_name = team_names_hash[game[:team_name]]
      team_name[:goals] += game[:goals].to_i
      team_name[:games] += 1
      team_name[:average] = (team_name[:goals].to_f / team_name[:games]).round(2)
    end
    team_names_hash.max_by { |team| team[1][:average] }[0]
  end

  # Iteration 3
  # Description: Name of the team with the highest average score per game across all seasons when they are home.
  # Return Value: String
  def highest_scoring_home_team
    team_ids_hash = Hash.new
    @teams.each do |team|
      team_ids_hash[team[:team_id]] = {goals: 0, games: 0, average: 0}
    end

    @combine_data.each do |game|
      team_id = team_ids_hash[game[:home_team_id]]
      team_id[:goals] += game[:home_goals].to_i
      team_id[:games] += 1
      team_id[:average] = (team_id[:goals].to_f / team_id[:games]).round(2)
    end
    high_scoring_home_id = team_ids_hash.max_by { |team| team[1][:average] }[0]

    high_scoring_home_team = @teams.find do |team|
      team[:team_id] == high_scoring_home_id
    end
    high_scoring_home_team[:team_name]
  end

# Description: Name of the team with the highest average number of goals allowed per game across all seasons
  def worst_defense
    team_ids_hash = Hash.new
    @teams.each do |team|
      team_ids_hash[team[:team_id]] = {goals_against: 0, games: 0, average: 0}
    end

    @combine_data.each do |game|
      home_team_id = team_ids_hash[game[:home_team_id]]
      home_team_id[:goals_against] += game[:away_goals].to_i
      home_team_id[:games] += 1
      home_team_id[:average] = (home_team_id[:goals_against].to_f / home_team_id[:games]).round(3)

      away_team_id = team_ids_hash[game[:away_team_id]]
      away_team_id[:goals_against] += game[:home_goals].to_i
      away_team_id[:games] += 1
      away_team_id[:average] = (away_team_id[:goals_against].to_f / away_team_id[:games]).round(3)
    end
    worst_defense_id = team_ids_hash.max_by { |team| team[1][:average] }[0]
    worst_defense = @teams.find do |team|
      team[:team_id] == worst_defense_id
    end
    worst_defense[:team_name]
  end

  # Description: Name of the team with the highest win percentage across all seasons
  # Return Value: String
  def winningest_team
    team_ids_hash = Hash.new
    @teams.each do |team|
      team_ids_hash[team[:team_id]] = {games_won: 0, games: 0, average: 0}
    end

    @game_teams.each do |game|
      team_id = team_ids_hash[game[:team_id]]
      team_id[:games_won] += 1 if game[:won] == "TRUE"
      team_id[:games] += 1
      team_id[:average] = (team_id[:games_won].to_f / team_id[:games]).round(3)
    end

    winningest_id = team_ids_hash.max_by { |team| team[1][:average] }[0]
    winningest_team = @teams.find do |team|
      team[:team_id] == winningest_id
    end

    winningest_team[:team_name]
  end
end # module end
