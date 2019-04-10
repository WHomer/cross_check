module TeamStatistics
  def team_info(team_id)
    results = @teams.find { |team| team[:team_id] == team_id.to_i }
    {
      'team_id' => results[:team_id].to_s,
      'franchise_id' => results[:franchise_id].to_s,
      'short_name' => results[:short_name],
      'team_name' => results[:team_name],
      'abbreviation' => results[:abbreviation],
      'link' => results[:team_link]
    }
  end

  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    result = @game_teams.map { |game| game[:goals] if game[:team_id] == team_id }
    result.compact.min
  end

  def most_goals_scored(team_id)
    team_id = team_id.to_i
    result = @game_teams.map { |game| game[:goals] if game[:team_id] == team_id }
    result.compact.max
  end

  def biggest_team_blowout(team_id)
    @games.map do |game|
      game[:away_team_id].to_s == team_id ? game[:away_goals] - game[:home_goals] : nil
      game[:home_team_id].to_s == team_id ? game[:home_goals] - game[:away_goals] : nil
    end.compact.max
  end

  def worst_loss(input)
    team_data = @combine_data.find_all do |game|
      game[:team_id] == input.to_i && game[:won] == 'FALSE'
    end
    result = team_data.max_by { |game| (game[:away_goals] - game[:home_goals]).abs }
    (result[:away_goals] - result[:home_goals]).abs
  end

  def favorite_opponent(input)
    games = @game_teams.each_with_object({}) do |game, hash|
      hash[game[:game_id]] = { teams: [], winner: '', loser: '' } if hash[game[:game_id]].nil?
      hash[game[:game_id]][:teams] << game[:team_id]
      hash[game[:game_id]][:winner] = game[:team_id] if game[:won] == 'TRUE'
      hash[game[:game_id]][:loser] = game[:team_id] if game[:won] == 'FALSE'
    end
    teams_loss_data = games.each_with_object({}) do |game, hash|
      next unless game[1][:teams][0] == input.to_i || game[1][:teams][1] == input.to_i

      losing_team_id = game[1][:loser]
      winning_team_id = game[1][:winner]
      hash[losing_team_id] = { loss: 0, total_games: 0, average: 0 } if hash[losing_team_id].nil?
      hash[winning_team_id] = { loss: 0, total_games: 0, average: 0 } if hash[winning_team_id].nil?
      if game[1][:winner] == input.to_i
        hash[losing_team_id][:loss] += 1
        hash[losing_team_id][:total_games] += 1
        hash[losing_team_id][:average] = (hash[losing_team_id][:loss].to_f / hash[losing_team_id][:total_games])
      else
        hash[winning_team_id][:total_games] += 1
        hash[winning_team_id][:average] = (hash[winning_team_id][:loss].to_f / hash[winning_team_id][:total_games])
      end
    end
    team_id = teams_loss_data.max_by { |team_data| team_data[1][:average] }
    @teams.find { |team| team[:team_id] == team_id[0] }[:team_name]
  end

  def average_win_percentage(input)
    team_id = input.to_i
    results = @games.inject({}) do |hash, game|
      if game[:away_team_id] == team_id
        hash = { total_wins: 0, total_games: 0, percentage_won: 0 } if hash.to_a.empty?
        if game[:away_goals] > game[:home_goals]
          hash[:total_wins] += 1
          hash[:total_games] += 1
        else
          hash[:total_games] += 1
        end
        hash[:percentage_won] = hash[:total_wins].to_f / hash[:total_games]
      elsif game[:home_team_id] == team_id
        hash = { total_wins: 0, total_games: 0, percentage_won: 0 } if hash.to_a.empty?
        if game[:away_goals] < game[:home_goals]
          hash[:total_wins] += 1
          hash[:total_games] += 1
        else
          hash[:total_games] += 1
        end
        hash[:percentage_won] = hash[:total_wins].to_f / hash[:total_games]
      end
      hash
    end
    results[:percentage_won].round(2)
  end

  def best_season(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end

    seasons = {}
    teams_games_array.each do |game|
      seasons[game.values[1]] = { games_won: 0, games_played: 0, avg: 0 }
    end

    teams_games_array.each do |game|
      seasons[game[:season]][:games_played] += 1
      seasons[game[:season]][:avg] = (seasons[game[:season]][:games_won].to_f / seasons[game[:season]][:games_played]).round(3)
      if team_id.to_i == game[:home_team_id] && game[:outcome].include?('home')
        seasons[game[:season]][:games_won] += 1
      elsif team_id.to_i == game[:away_team_id] && game[:outcome].include?('away')
        seasons[game[:season]][:games_won] += 1
      end
    end

    seasons.max_by { |season| season[1][:avg] }[0].to_s
  end

  def worst_season(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end
    seasons = {}
    teams_games_array.each do |game|
      seasons[game.values[1]] = { games_won: 0, games_played: 0, avg: 0 }
    end

    teams_games_array.each do |game|
      seasons[game[:season]][:games_played] += 1
      seasons[game[:season]][:avg] = (seasons[game[:season]][:games_won].to_f / seasons[game[:season]][:games_played]).round(3)
      if team_id.to_i == game[:home_team_id] && game[:outcome].include?('home')
        seasons[game[:season]][:games_won] += 1
      elsif team_id.to_i == game[:away_team_id] && game[:outcome].include?('away')
        seasons[game[:season]][:games_won] += 1
      end
    end
    seasons.min_by { |season| season[1][:avg] }[0].to_s
  end

  def rival(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end

    all_team_ids_hash = Hash.new
    @teams.each do |team|
      all_team_ids_hash[team[:team_id]] = {wins: 0, games: 0, average: 0}
    end

    teams_games_array.each do |game|
      if team_id.to_i == game[:home_team_id]
        opp_is_away_id = all_team_ids_hash[game[:away_team_id]]
        opp_is_away_id[:wins] += 1 if game[:outcome].include?("away")
        opp_is_away_id[:games] += 1
        opp_is_away_id[:average] = (opp_is_away_id[:wins].to_f / opp_is_away_id[:games]).round(3)
      elsif team_id.to_i == game[:away_team_id]
        opp_is_home_id = all_team_ids_hash[game[:home_team_id]]
        opp_is_home_id[:wins] += 1 if game[:outcome].include?("home")
        opp_is_home_id[:games] += 1
        opp_is_home_id[:average] = (opp_is_home_id[:wins].to_f / opp_is_home_id[:games]).round(3)
      end
    end

    all_team_ids_hash.max_by { |team| team[1][:average] }[0]
    rival_id = all_team_ids_hash.max_by { |team| team[1][:average] }[0]
    rival_name = @teams.find do |team|
      team[:team_id] == rival_id
    end
    rival_name[:team_name]
  end

  def head_to_head(team_id)
    teams_games_array = []
    @games.each do |game|
      if game[:away_team_id] == team_id.to_i || game[:home_team_id] == team_id.to_i
        teams_games_array << game
      end
    end

    all_team_ids_hash = Hash.new
    @teams.each do |team|
      all_team_ids_hash[team[:team_id]] = {wins: 0, games: 0, average: 0}
    end

    teams_games_array.each do |game|
      if team_id.to_i == game[:home_team_id]
        opp_is_away_id = all_team_ids_hash[game[:away_team_id]]
        opp_is_away_id[:wins] += 1 if game[:outcome].include?("home")
        opp_is_away_id[:games] += 1
        opp_is_away_id[:average] = (opp_is_away_id[:wins].to_f / opp_is_away_id[:games]).round(2)
      elsif team_id.to_i == game[:away_team_id]
        opp_is_home_id = all_team_ids_hash[game[:home_team_id]]
        opp_is_home_id[:wins] += 1 if game[:outcome].include?("away")
        opp_is_home_id[:games] += 1
        opp_is_home_id[:average] = (opp_is_home_id[:wins].to_f / opp_is_home_id[:games]).round(2)
      end
    end

    team_names_hash = Hash.new
    all_team_ids_hash.each do |team|
      @teams.find_all do |team|
        all_team_ids_hash[team[:team_id]] == team[:team_id]
        team_names_hash[team[:team_name]] = all_team_ids_hash[team[:team_id]][:average] if all_team_ids_hash[team[:team_id]][:average] > 0
      end
    end
    team_names_hash
  end

  def seasonal_summary(team_id)
    #For each season that the team has played, a hash that has two keys (:regular_season and :postseason), 
    #that each point to a hash with the following keys: :win_percentage, :total_goals_scored, :total_goals_against, :average_goals_scored, :average_goals_against.
    season_summary = @games.uniq{|game| game[:season]}.inject({}) do |hash, season|
      hash[season[:season].to_s] = {
        postseason: {
          :win_percentage=>0.0,
          :total_goals_scored=>0,
          :total_goals_against=>0,
          :average_goals_scored=>0.0,
          :average_goals_against=>0.0,
          :number_of_wins => 0,
          :number_of_games => 0},
        regular_season: {
          :win_percentage=>0.0,
          :total_goals_scored=>0,  #
          :total_goals_against=>0, #
          :average_goals_scored=>0.0,
          :average_goals_against=>0.0,
          :number_of_wins => 0,
          :number_of_games => 0}
      }
      hash
    end

    @combine_data.each do |game|
      season_id = game[:season].to_s
      team_id = team_id.to_i
      if game[:away_team_id] == team_id || game[:home_team_id] == team_id
        if game[:type] == 'R' 
          if game[:team_id] == team_id
            if game[:home_team_id] == team_id
              season_summary[season_id][:regular_season][:total_goals_scored] += game[:home_goals]
            elsif game[:away_team_id] == team_id
              season_summary[season_id][:regular_season][:total_goals_scored] += game[:away_goals]
            end
            season_summary[season_id][:regular_season][:number_of_games] += 1
            season_summary[season_id][:regular_season][:number_of_wins] += 1 if game[:won] == "TRUE"
          elsif game[:team_id] != team_id
            if game[:home_team_id] != team_id
              season_summary[season_id][:regular_season][:total_goals_against] += game[:home_goals]
            elsif game[:away_team_id] != team_id
              season_summary[season_id][:regular_season][:total_goals_against] += game[:away_goals]
            end
          end
          season_summary[season_id][:regular_season][:average_goals_scored] = (season_summary[season_id][:regular_season][:total_goals_scored].to_f / season_summary[season_id][:regular_season][:number_of_games]).round(2)
          season_summary[season_id][:regular_season][:average_goals_against] = (season_summary[season_id][:regular_season][:total_goals_against].to_f / season_summary[season_id][:regular_season][:number_of_games]).round(2)
          season_summary[season_id][:regular_season][:win_percentage] = (season_summary[season_id][:regular_season][:number_of_wins].to_f / season_summary[season_id][:regular_season][:number_of_games]).round(2)
        elsif game[:type] == 'P'
          if game[:team_id] == team_id
            if game[:home_team_id] == team_id
              season_summary[season_id][:postseason][:total_goals_scored] += game[:home_goals]
            elsif game[:away_team_id] == team_id
              season_summary[season_id][:postseason][:total_goals_scored] += game[:away_goals]
            end
            season_summary[season_id][:postseason][:number_of_games] += 1
            season_summary[season_id][:postseason][:number_of_wins] += 1 if game[:won] == "TRUE"
          elsif game[:team_id] != team_id
            if game[:home_team_id] != team_id
              season_summary[season_id][:postseason][:total_goals_against] += game[:home_goals]
            elsif game[:away_team_id] != team_id
              season_summary[season_id][:postseason][:total_goals_against] += game[:away_goals]
            end
          end
          if season_summary[season_id][:postseason][:number_of_games] > 0
            season_summary[season_id][:postseason][:average_goals_scored] = (season_summary[season_id][:postseason][:total_goals_scored].to_f / season_summary[season_id][:postseason][:number_of_games]).round(2)
            season_summary[season_id][:postseason][:average_goals_against] = (season_summary[season_id][:postseason][:total_goals_against].to_f / season_summary[season_id][:postseason][:number_of_games]).round(2)
            season_summary[season_id][:postseason][:win_percentage] = (season_summary[season_id][:postseason][:number_of_wins].to_f / season_summary[season_id][:postseason][:number_of_games]).round(2)
          end
        end
      end
    end
    season_summary.each do |season|
      season[1][:postseason].delete(:number_of_wins)
      season[1][:postseason].delete(:number_of_games)
      season[1][:regular_season].delete(:number_of_wins)
      season[1][:regular_season].delete(:number_of_games)
    end
  end

end # module end
