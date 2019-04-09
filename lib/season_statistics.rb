module SeasonStatistics
  def biggest_bust(season)
    data = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        post_season_won: 0,
        post_season_lost: 0,
        post_season_win_percentage: 0,
        regular_season_won: 0,
        regular_season_lost: 0,
        regular_season_win_percentage: 0,
        biggest_bust_value: 0}
      hash
    end
    season_data = @combine_data.find_all{|record| record[:season].to_s == season.to_s}
    season_data.map do |row|
      if row[:type] == 'P'
        data[row[:team_name]][:post_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:post_season_lost] += 1 if row[:won].to_s == "FALSE"
      elsif row[:type] == 'R'
        data[row[:team_name]][:regular_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:regular_season_lost] += 1 if row[:won].to_s == "FALSE"
      end
      if data[row[:team_name]][:post_season_won] > 0 || data[row[:team_name]][:post_season_lost] > 0
        data[row[:team_name]][:post_season_win_percentage] = (data[row[:team_name]][:post_season_won].to_f / (data[row[:team_name]][:post_season_won] + data[row[:team_name]][:post_season_lost])) * 100
        data[row[:team_name]][:regular_season_win_percentage] = (data[row[:team_name]][:regular_season_won].to_f / (data[row[:team_name]][:regular_season_won] + data[row[:team_name]][:regular_season_lost])) * 100
        data[row[:team_name]][:biggest_bust_value] = data[row[:team_name]][:post_season_win_percentage] - data[row[:team_name]][:regular_season_win_percentage]
      end
    end
    data.min_by{|team| team[1][:biggest_bust_value]}[0]
  end

  def biggest_surprise(season)
    data = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        post_season_won: 0,
        post_season_lost: 0,
        post_season_win_percentage: 0,
        regular_season_won: 0,
        regular_season_lost: 0,
        regular_season_win_percentage: 0,
        biggest_bust_value: 0}
      hash
    end
    season_data = @combine_data.find_all{|record| record[:season].to_s == season.to_s}
    season_data.map do |row|
      if row[:type] == 'P'
        data[row[:team_name]][:post_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:post_season_lost] += 1 if row[:won].to_s == "FALSE"
      elsif row[:type] == 'R'
        data[row[:team_name]][:regular_season_won] += 1 if row[:won].to_s == "TRUE"
        data[row[:team_name]][:regular_season_lost] += 1 if row[:won].to_s == "FALSE"
      end
      if data[row[:team_name]][:post_season_won] > 0 || data[row[:team_name]][:post_season_lost] > 0
        data[row[:team_name]][:post_season_win_percentage] = (data[row[:team_name]][:post_season_won].to_f / (data[row[:team_name]][:post_season_won] + data[row[:team_name]][:post_season_lost])) * 100
        data[row[:team_name]][:regular_season_win_percentage] = (data[row[:team_name]][:regular_season_won].to_f / (data[row[:team_name]][:regular_season_won] + data[row[:team_name]][:regular_season_lost])) * 100
        data[row[:team_name]][:biggest_bust_value] = data[row[:team_name]][:post_season_win_percentage] - data[row[:team_name]][:regular_season_win_percentage]
      end
    end
    data.max_by{|team| team[1][:biggest_bust_value]}[0]
  end

  def most_accurate_team(season)
    teams_array = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        shots_on_goal: 0,
        goals: 0,
        average: 0}
      hash
    end
    @combine_data.each do |game|
      if game[:season].to_s == season.to_s
        teams_array[game[:team_name]][:shots_on_goal] += game[:shots]
        teams_array[game[:team_name]][:goals] += game[:goals]
        teams_array[game[:team_name]][:average] = (teams_array[game[:team_name]][:goals] / teams_array[game[:team_name]][:shots_on_goal].to_f) * 100
      end
    end
    teams_array.max_by{|team| team[1][:average]}[0]
  end

  # Description: Name of the Team with the worst ratio of shots to goals for the season
  # Return Value: String
  def least_accurate_team(season)
    teams_array = @teams.inject({}) do |hash, value|
      hash[value[:team_name]] = {
        shots_on_goal: 0,
        goals: 0,
        average: 0}
        hash
      end

      @combine_data.each do |game|
        if game[:season].to_s == season.to_s
          teams_array[game[:team_name]][:shots_on_goal] += game[:shots]
          teams_array[game[:team_name]][:goals] += game[:goals]
          teams_array[game[:team_name]][:average] = (teams_array[game[:team_name]][:goals] / teams_array[game[:team_name]][:shots_on_goal].to_f) * 100
        end
      end
      teams_with_data = teams_array.delete_if { |k,v| v[:average] <= 0 }
      teams_with_data.min_by{|team| team[1][:average]}[0]
  end

end
