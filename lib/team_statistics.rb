module TeamStatistics
  def team_info(team_id)
    #	A hash with key/value pairs for each of the attributes of a team.
    @teams.find{|team| team["team_id"] == team_id.to_s}
  end
end
