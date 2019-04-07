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

  #   #	A hash with key/value pairs for each of the attributes of a team.
  #   @teams.find { |team| team[:team_id] == team_id}
  end

  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    result = @game_teams.map { |game| game[:goals] if game[:team_id] == team_id }
    result.compact.min
  end

  def biggest_team_blowout(team_id)
    @games.map do |game|
      game[:away_team_id].to_s == team_id ? game[:away_goals] - game[:home_goals] : nil
      game[:home_team_id].to_s == team_id ? game[:home_goals] - game[:away_goals] : nil
    end.compact.max
  end
end
