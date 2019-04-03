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


end
