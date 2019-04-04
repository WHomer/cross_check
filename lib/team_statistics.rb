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
    #give 18 expect 6 ,,, 18 is team id nashville
    team_data = @combine_data.find_all do |game|
      game[:team_id] == input.to_i && game[:won] == "FALSE"
    end
    result = team_data.max_by{|game| (game[:away_goals] - game[:home_goals]).abs}
    (result[:away_goals] - result[:home_goals]).abs
  end


end
