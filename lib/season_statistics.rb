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
end
