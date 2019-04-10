module League
  def count_of_teams
    @teams.count
  end

  def best_fans
    results = @combine_data.each_with_object({}) do |game, hash|
      hash[game[:team_id]] = { team_name: game[:team_name], home_wins: 0, home_games: 0, away_wins: 0, away_games: 0, away_per: 0, home_per: 0, difference: 0 } if hash[game[:team_id]].nil?
      if game[:hoa] == 'home'
        hash[game[:team_id]][:home_wins] += 1 if game[:outcome].include?('home')
        hash[game[:team_id]][:home_games] += 1
      elsif game[:hoa] == 'away'
        hash[game[:team_id]][:away_wins] += 1 if game[:outcome].include?('away')
        hash[game[:team_id]][:away_games] += 1
      end
      hash[game[:team_id]][:away_per] = (hash[game[:team_id]][:away_wins].to_f / hash[game[:team_id]][:away_games]).round(3)
      hash[game[:team_id]][:home_per] = (hash[game[:team_id]][:home_wins].to_f / hash[game[:team_id]][:home_games]).round(3)
      hash[game[:team_id]][:difference] = hash[game[:team_id]][:home_per] - hash[game[:team_id]][:away_per]
    end
    results.max_by { |team| team[1][:difference] }[1][:team_name]
  end

  def highest_scoring_visitor
    away_games = @combine_data.find_all { |game| game[:hoa] == 'away' }
    results = away_games.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].nil?
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.max_by { |team| team[1][:average] }.first
  end

  def highest_scoring_home_team
    home_games = @combine_data.find_all { |game| game[:hoa] == 'home' }
    results = home_games.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].nil?
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.max_by { |team| team[1][:average] }.first
  end

  def worst_offense
    results = @combine_data.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].nil?
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.min_by { |team| team[1][:average] }.first
  end

  def worst_fans
    results = @combine_data.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { home_wins: 0, home_loss: 0, away_wins: 0, away_loss: 0, difference: 0 } if hash[game[:team_name]].nil?
      if game[:hoa] == 'home' && game[:won] == 'TRUE'
        hash[game[:team_name]][:home_wins] += 1
      elsif game[:hoa] == 'away' && game[:won] == 'TRUE'
        hash[game[:team_name]][:away_wins] += 1
      end
      hash[game[:team_name]][:difference] = hash[game[:team_name]][:away_wins] - hash[game[:team_name]][:home_wins]
    end
    results.each_with_object([]) { |team, array| array << team[0] if team[1][:difference] >= 0; }
  end

  def lowest_scoring_visitor
    away_games = @combine_data.find_all { |game| game[:hoa] == 'away' }
    results = away_games.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].nil?
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.min_by { |team| team[1][:average] }.first
  end

  def worst_defense
    id_hash = {}
    @teams.each { |team| id_hash[team[:team_id]] = { goals_against: 0, games: 0, average: 0 } }
    @combine_data.each do |game|
      home_team_id = id_hash[game[:home_team_id]]
      home_team_id[:goals_against] += game[:away_goals].to_i
      home_team_id[:games] += 1
      home_team_id[:average] = (home_team_id[:goals_against].to_f / home_team_id[:games]).round(3)
      away_team_id = id_hash[game[:away_team_id]]
      away_team_id[:goals_against] += game[:home_goals].to_i
      away_team_id[:games] += 1
      away_team_id[:average] = (away_team_id[:goals_against].to_f / away_team_id[:games]).round(3)
    end
    worst_id = id_hash.max_by { |team| team[1][:average] }[0]
    worst = @teams.find { |team| team[:team_id] == worst_id }
    worst[:team_name]
  end

  def best_defense
    id_hash = {}
    @teams.each { |team| id_hash[team[:team_id]] = { goals_against: 0, games: 0, average: 0 } }
    @combine_data.each do |game|
      home_team_id = id_hash[game[:home_team_id]]
      home_team_id[:goals_against] += game[:away_goals].to_i
      home_team_id[:games] += 1
      home_team_id[:average] = (home_team_id[:goals_against].to_f / home_team_id[:games]).round(3)
      away_team_id = id_hash[game[:away_team_id]]
      away_team_id[:goals_against] += game[:home_goals].to_i
      away_team_id[:games] += 1
      away_team_id[:average] = (away_team_id[:goals_against].to_f / away_team_id[:games]).round(3)
    end
    data = id_hash.delete_if { |_k, v| v[:average] <= 0 }
    best_id = data.min_by { |team| team[1][:average] }[0]
    best = @teams.find { |team| team[:team_id] == best_id }
    best[:team_name]
  end

  def winningest_team
    id_hash = Hash.new
    @teams.each do |team|
      id_hash[team[:team_id]] = { games_won: 0, games: 0, average: 0 }
    end
    @game_teams.each do |game|
      team_id = id_hash[game[:team_id]]
      game[:won] == 'TRUE' ? team_id[:games_won] += 1 : nil
      team_id[:games] += 1
      team_id[:average] = (team_id[:games_won].to_f / team_id[:games]).round(3)
    end
    win_id = id_hash.max_by { |team| team[1][:average] }[0]
    win = @teams.find { |team| team[:team_id] == win_id }
    win[:team_name]
  end

  def lowest_scoring_home_team
    id_hash = Hash.new
    @teams.each do |team|
      id_hash[team[:team_id]] = { goals: 0, games: 0, average: 0 }
    end
    @combine_data.each do |game|
      team_id = id_hash[game[:home_team_id]]
      team_id[:goals] += game[:home_goals].to_i
      team_id[:games] += 1
      team_id[:average] = (team_id[:goals].to_f / team_id[:games]).round(2)
    end
    data = id_hash.delete_if { |key, value| value[:average] <= 0 }
    low_id = data.min_by { |team| team[1][:average] }[0]
    lowest = @teams.find { |team| team[:team_id] == low_id }
    lowest[:team_name]
  end

  def best_offense
    id_hash = Hash.new
    @teams.each do |team|
      id_hash[team[:team_name]] = { goals: 0, games: 0, average: 0 }
    end
    @combine_data.each do |game|
      team_name = id_hash[game[:team_name]]
      team_name[:goals] += game[:goals].to_i
      team_name[:games] += 1
      team_name[:average] = (team_name[:goals].to_f / team_name[:games]).round(2)
    end
    id_hash.max_by { |team| team[1][:average] }[0]
  end
end
