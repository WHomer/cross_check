module SeasonStatistics
  def biggest_bust(season)
    #Name of the team with the biggest decrease between regular season and postseason win percentage.
    #season with the biggest regular season and post season win
    #return team, pass season "20132014" = "Lightning"
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

  def power_play_goal_data(season)
    all_games_in_season(season)
    power_play_goals_data = Hash.new { |hash, key| hash[key] = [0, 0] }
    game_teams.each do |game|
      if @full_season_games.include?(game.game_id)
        power_play_goals_data[season][1] += game.power_play_goals
        power_play_goals_data[season][0] += game.goals
      end
    end
    power_play_percentage = {}
    power_play_goals_data.each do |key, value|
      power_play_percentage[key] = (value[1].to_f / value[0]).round(2)
    end
    power_play_percentage[season]
  end
end
