module TeamStatistics
  def team_info(team_id)
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

end # module end
