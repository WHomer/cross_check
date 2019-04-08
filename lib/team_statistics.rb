module TeamStatistics
  def team_info(team_id)
    results = @teams.find{|team| team[:team_id] == team_id}
    {
      "team_id" => results[:team_id].to_s,
      "franchise_id" => results[:franchise_id].to_s,
      "short_name" => results[:short_name],
      "team_name" => results[:team_name],
      "abbreviation" => results[:abbreviation],
      "link" => results[:team_link]
    }
  end

  def worst_loss(input)
    team_data = @combine_data.find_all do |game|
      game[:team_id] == input.to_i && game[:won] == "FALSE"
    end
    result = team_data.max_by{|game| (game[:away_goals] - game[:home_goals]).abs}
    (result[:away_goals] - result[:home_goals]).abs
  end

  def favorite_opponent(input)
    games = @game_teams.inject({}) do |hash, game|
      hash[game[:game_id]] = {teams: [], winner: '', loser: ''} if hash[game[:game_id]].nil?
      hash[game[:game_id]][:teams] << game[:team_id]
      hash[game[:game_id]][:winner] = game[:team_id] if game[:won] == "TRUE"
      hash[game[:game_id]][:loser] = game[:team_id] if game[:won] == "FALSE"
      hash
    end
    teams_loss_data = games.inject({}) do |hash, game|
      if game[1][:teams][0] == input.to_i  || game[1][:teams][1] == input.to_i 
        losing_team_id = game[1][:loser]
        winning_team_id = game[1][:winner]
        hash[losing_team_id] = {loss: 0, total_games: 0, average: 0} if hash[losing_team_id].nil?
        hash[winning_team_id] = {loss: 0, total_games: 0, average: 0} if hash[winning_team_id].nil?
        if game[1][:winner] == input.to_i 
          hash[losing_team_id][:loss] += 1
          hash[losing_team_id][:total_games] += 1
          hash[losing_team_id][:average] = (hash[losing_team_id][:loss].to_f / hash[losing_team_id][:total_games])
        else
          hash[winning_team_id][:total_games] += 1
          hash[winning_team_id][:average] = (hash[winning_team_id][:loss].to_f / hash[winning_team_id][:total_games])
        end
      end
      hash
    end
    team_id = teams_loss_data.max_by{|team_data| team_data[1][:average]}
    @teams.find{|team| team[:team_id] == team_id[0]}[:team_name]
  end

  def average_win_percentage(input)
    # average_win_percentage	Average win percentage of all games for a team.
    team_id = input.to_i
    results = @games.inject({}) do |hash, game|
      if game[:away_team_id] == team_id
        hash = {total_wins: 0, total_games: 0, percentage_won: 0} if hash.to_a.length == 0
        if game[:away_goals] > game[:home_goals]
          hash[:total_wins] += 1
          hash[:total_games] += 1
        else
          hash[:total_games] += 1
        end
        hash[:percentage_won] = hash[:total_wins].to_f / hash[:total_games] 
      elsif game[:home_team_id] == team_id
        hash = {total_wins: 0, total_games: 0, percentage_won: 0} if hash.to_a.length == 0
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
    #	A hash with key/value pairs for each of the attributes of a team.
    @teams.find{|team| team["team_id"] == team_id.to_s}
  end

  # Description: Season with the highest win percentage for a team.
  # Return Value: Integer
  def best_season(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end

    seasons = Hash.new
    teams_games_array.each do |game|
      seasons[game.values[1]] = {games_won: 0, games_played: 0, avg: 0}
    end

    teams_games_array.each do |game|
      seasons[game[:season]][:games_played] += 1
      seasons[game[:season]][:avg] = (seasons[game[:season]][:games_won].to_f / seasons[game[:season]][:games_played]).round(3)
      if team_id.to_i == game[:home_team_id] && game[:outcome].include?("home")
        seasons[game[:season]][:games_won] += 1
      elsif team_id.to_i == game[:away_team_id] && game[:outcome].include?("away")
        seasons[game[:season]][:games_won] += 1
       end
    end

    highest_winning_percentage_season = seasons.max_by { |season| season[1][:avg]}[0].to_s
  end

  # # Description: Highest number of goals a particular team has scored in a single game.
  # # Return Value: Integer
  # def most_goals_scored(team_id)
  #
  # end


end # module end
