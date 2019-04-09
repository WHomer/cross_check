module TeamStatistics
  def team_info(team_id)
    results = @teams.find { |team| team[:team_id] == team_id.to_i }
    {
      'team_id' => results[:team_id].to_s,
      'franchise_id' => results[:franchise_id].to_s,
      'short_name' => results[:short_name],
      'team_name' => results[:team_name],
      'abbreviation' => results[:abbreviation],
      'link' => results[:team_link]
    }
  end

  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    result = @game_teams.map { |game| game[:goals] if game[:team_id] == team_id }
    result.compact.min
  end

  def most_goals_scored(team_id)
    team_id = team_id.to_i
    result = @game_teams.map { |game| game[:goals] if game[:team_id] == team_id }
    result.compact.max
  end

  def biggest_team_blowout(team_id)
    @games.map do |game|
      game[:away_team_id].to_s == team_id ? game[:away_goals] - game[:home_goals] : nil
      game[:home_team_id].to_s == team_id ? game[:home_goals] - game[:away_goals] : nil
    end.compact.max
  end

  def worst_loss(input)
    team_data = @combine_data.find_all do |game|
      game[:team_id] == input.to_i && game[:won] == 'FALSE'
    end
    result = team_data.max_by { |game| (game[:away_goals] - game[:home_goals]).abs }
    (result[:away_goals] - result[:home_goals]).abs
  end

  def favorite_opponent(input)
    games = @game_teams.each_with_object({}) do |game, hash|
      hash[game[:game_id]] = { teams: [], winner: '', loser: '' } if hash[game[:game_id]].nil?
      hash[game[:game_id]][:teams] << game[:team_id]
      hash[game[:game_id]][:winner] = game[:team_id] if game[:won] == 'TRUE'
      hash[game[:game_id]][:loser] = game[:team_id] if game[:won] == 'FALSE'
    end
    teams_loss_data = games.each_with_object({}) do |game, hash|
      next unless game[1][:teams][0] == input.to_i || game[1][:teams][1] == input.to_i

      losing_team_id = game[1][:loser]
      winning_team_id = game[1][:winner]
      hash[losing_team_id] = { loss: 0, total_games: 0, average: 0 } if hash[losing_team_id].nil?
      hash[winning_team_id] = { loss: 0, total_games: 0, average: 0 } if hash[winning_team_id].nil?
      if game[1][:winner] == input.to_i
        hash[losing_team_id][:loss] += 1
        hash[losing_team_id][:total_games] += 1
        hash[losing_team_id][:average] = (hash[losing_team_id][:loss].to_f / hash[losing_team_id][:total_games])
      else
        hash[winning_team_id][:total_games] += 1
        hash[winning_team_id][:average] = (hash[winning_team_id][:loss].to_f / hash[winning_team_id][:total_games])
      end
    end
    team_id = teams_loss_data.max_by { |team_data| team_data[1][:average] }
    @teams.find { |team| team[:team_id] == team_id[0] }[:team_name]
  end

  def average_win_percentage(input)
    team_id = input.to_i
    results = @games.inject({}) do |hash, game|
      if game[:away_team_id] == team_id
        hash = { total_wins: 0, total_games: 0, percentage_won: 0 } if hash.to_a.empty?
        if game[:away_goals] > game[:home_goals]
          hash[:total_wins] += 1
          hash[:total_games] += 1
        else
          hash[:total_games] += 1
        end
        hash[:percentage_won] = hash[:total_wins].to_f / hash[:total_games]
      elsif game[:home_team_id] == team_id
        hash = { total_wins: 0, total_games: 0, percentage_won: 0 } if hash.to_a.empty?
        if game[:away_goals] < game[:home_goals]
          hash[:total_wins] += 1
          hash[:total_games] += 1
        else
          hash[:total_games] += 1
        end
        hash[:percentage_won] = hash[:total_wins].to_f / hash[:total_games]
      end
      hash
    end
    results[:percentage_won].round(2)
  end

  def best_season(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end

    seasons = {}
    teams_games_array.each do |game|
      seasons[game.values[1]] = { games_won: 0, games_played: 0, avg: 0 }
    end

    teams_games_array.each do |game|
      seasons[game[:season]][:games_played] += 1
      seasons[game[:season]][:avg] = (seasons[game[:season]][:games_won].to_f / seasons[game[:season]][:games_played]).round(3)
      if team_id.to_i == game[:home_team_id] && game[:outcome].include?('home')
        seasons[game[:season]][:games_won] += 1
      elsif team_id.to_i == game[:away_team_id] && game[:outcome].include?('away')
        seasons[game[:season]][:games_won] += 1
      end
    end

    seasons.max_by { |season| season[1][:avg] }[0].to_s
  end

  def worst_season(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end
    seasons = {}
    teams_games_array.each do |game|
      seasons[game.values[1]] = { games_won: 0, games_played: 0, avg: 0 }
    end

    teams_games_array.each do |game|
      seasons[game[:season]][:games_played] += 1
      seasons[game[:season]][:avg] = (seasons[game[:season]][:games_won].to_f / seasons[game[:season]][:games_played]).round(3)
      if team_id.to_i == game[:home_team_id] && game[:outcome].include?('home')
        seasons[game[:season]][:games_won] += 1
      elsif team_id.to_i == game[:away_team_id] && game[:outcome].include?('away')
        seasons[game[:season]][:games_won] += 1
      end
    end
    seasons.min_by { |season| season[1][:avg] }[0].to_s
  end
end
