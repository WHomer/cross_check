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


end
