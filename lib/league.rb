module League

  def count_of_teams
    @teams.count
  end

  def highest_scoring_visitor
    away_games = @combine_data.find_all{|game| game[:hoa] == "away"}
    results = away_games.inject({}) do |hash, game|
      hash[game[:team_name]] = {goals: 0,games: 0,average: 0} if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
      hash
    end
    results.max_by{|team| team[1][:average]}.first
  end

  def highest_scoring_home_team
    home_games = @combine_data.find_all{|game| game[:hoa] == "home"}
    results = home_games.inject({}) do |hash, game|
      hash[game[:team_name]] = {goals: 0,games: 0,average: 0} if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
      hash
    end
    results.max_by{|team| team[1][:average]}.first
  end

  def worst_offense
    # Name of the team with the lowest average number
    # of goals scored per game across all seasons.
    results = @combine_data.inject({}) do |hash, game|
      hash[game[:team_name]] = {goals: 0,games: 0,average: 0} if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
      hash
    end
    binding.pry
    results.min_by{|team| team[1][:average]}.first
  end
end
