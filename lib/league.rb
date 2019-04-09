require 'pry'

module League
  def count_of_teams
    # Total number of teams in the data.
    @teams.count
  end

  def highest_scoring_visitor
    away_games = @combine_data.find_all { |game| game[:hoa] == 'away' }
    results = away_games.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.max_by { |team| team[1][:average] }.first
  end

  def worst_offense
    # Name of the team with the lowest average number
    # of goals scored per game across all seasons.
    results = @combine_data.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.min_by { |team| team[1][:average] }.first
  end

  def worst_fans
    #  List of names of all teams with better away records than home records.
    results = @combine_data.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { home_wins: 0, home_loss: 0, away_wins: 0, away_loss: 0, difference: 0 } if hash[game[:team_name]].to_a.length < 5
      if game[:hoa] == 'home' && game[:won] == 'TRUE'
        hash[game[:team_name]][:home_wins] += 1
      elsif game[:hoa] == 'away' && game[:won] == 'TRUE'
        hash[game[:team_name]][:away_wins] += 1
      end
      hash[game[:team_name]][:difference] = hash[game[:team_name]][:away_wins] - hash[game[:team_name]][:home_wins]
    end
    results.each_with_object([]) { |team, array| array << team[0] if team[1][:difference] >= 0; }
  end

  def lowest_scoring_visitor
    away_games = @combine_data.find_all { |game| game[:hoa] == 'away' }
    results = away_games.each_with_object({}) do |game, hash|
      hash[game[:team_name]] = { goals: 0, games: 0, average: 0 } if hash[game[:team_name]].to_a.length < 3
      hash[game[:team_name]][:goals] += game[:goals]
      hash[game[:team_name]][:games] += 1
      hash[game[:team_name]][:average] = hash[game[:team_name]][:goals] / hash[game[:team_name]][:games].to_f
    end
    results.min_by { |team| team[1][:average] }.first
  end

  # Description: Name of the team with the highest average number of goals allowed per game across all seasons
    def worst_defense
      team_ids_hash = Hash.new
      @teams.each do |team|
        team_ids_hash[team[:team_id]] = {goals_against: 0, games: 0, average: 0}
      end

      @combine_data.each do |game|
        home_team_id = team_ids_hash[game[:home_team_id]]
        home_team_id[:goals_against] += game[:away_goals].to_i
        home_team_id[:games] += 1
        home_team_id[:average] = (home_team_id[:goals_against].to_f / home_team_id[:games]).round(3)

        away_team_id = team_ids_hash[game[:away_team_id]]
        away_team_id[:goals_against] += game[:home_goals].to_i
        away_team_id[:games] += 1
        away_team_id[:average] = (away_team_id[:goals_against].to_f / away_team_id[:games]).round(3)
      end
      worst_defense_id = team_ids_hash.max_by { |team| team[1][:average] }[0]
      worst_defense = @teams.find do |team|
        team[:team_id] == worst_defense_id
      end
      worst_defense[:team_name]
    end

  # Description: Name of the team with the lowest average number of goals allowed per game across all seasons
    def best_defense
      team_ids_hash = Hash.new
      @teams.each do |team|
        team_ids_hash[team[:team_id]] = {goals_against: 0, games: 0, average: 0}
      end

      @combine_data.each do |game|
        home_team_id = team_ids_hash[game[:home_team_id]]
        home_team_id[:goals_against] += game[:away_goals].to_i
        home_team_id[:games] += 1
        home_team_id[:average] = (home_team_id[:goals_against].to_f / home_team_id[:games]).round(3)

        away_team_id = team_ids_hash[game[:away_team_id]]
        away_team_id[:goals_against] += game[:home_goals].to_i
        away_team_id[:games] += 1
        away_team_id[:average] = (away_team_id[:goals_against].to_f / away_team_id[:games]).round(3)
      end

      teams_with_data = team_ids_hash.delete_if { |k,v| v[:average] <= 0 }
      best_defense_id = teams_with_data.min_by { |team| team[1][:average] }[0]
      best_defense = @teams.find do |team|
        team[:team_id] == best_defense_id
      end
      best_defense[:team_name]
    end

    # Description: Name of the team with the highest win percentage across all seasons
    # Return Value: String
    def winningest_team
      team_ids_hash = Hash.new
      @teams.each do |team|
        team_ids_hash[team[:team_id]] = {games_won: 0, games: 0, average: 0}
      end

      @game_teams.each do |game|
        team_id = team_ids_hash[game[:team_id]]
        team_id[:games_won] += 1 if game[:won] == "TRUE"
        team_id[:games] += 1
        team_id[:average] = (team_id[:games_won].to_f / team_id[:games]).round(3)
      end

      winningest_id = team_ids_hash.max_by { |team| team[1][:average] }[0]
      winningest_team = @teams.find do |team|
        team[:team_id] == winningest_id
      end

      winningest_team[:team_name]
    end

    # Iteration 3
    # Description: Name of the team with the highest average score per game across all seasons when they are home.
    # Return Value: String
    def highest_scoring_home_team
      team_ids_hash = Hash.new
      @teams.each do |team|
        team_ids_hash[team[:team_id]] = {goals: 0, games: 0, average: 0}
      end

      @combine_data.each do |game|
        team_id = team_ids_hash[game[:home_team_id]]
        team_id[:goals] += game[:home_goals].to_i
        team_id[:games] += 1
        team_id[:average] = (team_id[:goals].to_f / team_id[:games]).round(2)
      end
      high_scoring_home_id = team_ids_hash.max_by { |team| team[1][:average] }[0]

      high_scoring_home_team = @teams.find do |team|
        team[:team_id] == high_scoring_home_id
      end
      high_scoring_home_team[:team_name]
    end

    # Iteration 3
    # Description: Name of the team with the lowest average score per game across all seasons when they are home.
    # Return Value: String
    def lowest_scoring_home_team
      team_ids_hash = Hash.new
      @teams.each do |team|
        team_ids_hash[team[:team_id]] = {goals: 0, games: 0, average: 0}
      end

      @combine_data.each do |game|
        team_id = team_ids_hash[game[:home_team_id]]
        team_id[:goals] += game[:home_goals].to_i
        team_id[:games] += 1
        team_id[:average] = (team_id[:goals].to_f / team_id[:games]).round(2)
      end

      teams_with_data = team_ids_hash.delete_if { |key,value| value[:average] <= 0 }
      low_scoring_home_id = teams_with_data.min_by { |team| team[1][:average] }[0]

      low_scoring_home_team = @teams.find do |team|
        team[:team_id] == low_scoring_home_id
      end
      low_scoring_home_team[:team_name]
    end

    # Iteration 3
    # Description: Name of the team with the highest average number
    # of goals scored per game across all seasons.
    # Return Value: String
    def best_offense
      team_names_hash = Hash.new
      @teams.each do |team|
        team_names_hash[team[:team_name]] = {goals: 0, games: 0, average: 0}
      end

      @combine_data.each do |game|
        team_name = team_names_hash[game[:team_name]]
        team_name[:goals] += game[:goals].to_i
        team_name[:games] += 1
        team_name[:average] = (team_name[:goals].to_f / team_name[:games]).round(2)
      end
      team_names_hash.max_by { |team| team[1][:average] }[0]
    end

  # def goals_allowed
  #   allowed = Hash.new { |hash, key| hash[key] = [] }
  #   @combine_data.each do |game|
  #     allowed[:home_team_id] << game[:away_goals]
  #     allowed[:away_team_id] << game[:home_goals]
  #   end
  #   avg = Hash.new { |hash, key| hash[key] = [] }
  #   allowed.each_key do |key|
  #     avg[key] << (allowed[key].sum.to_f / allowed[key].count).round(2)
  #   end
  #   team_id = goals_allowed.min_by { |value| value }
  #   @teams.find { |team| team[:team_id] == team_id }[:team_name]
  # end

  # def team_name_finder(attr)
  #   namer = teams.find do |team|
  #     team.team_id == attr[0]
  #   end
  #   "#{namer.team_name}"
  # end
end

# def team_name_finder(team_id)
#   @teams.find { |team| team[:team_id].to_s == [:team_name] }
# end

# def average_goals_against(games)
#   if games_played(games).count
#     (goals_against(games).to_f / games_played(games).count).round(2)
#   else
#     0.0
#   end
# end

#   def home_win
#     @games.size { |game| game[:outcome] == 'home' && game[:won] == 'TRUE' }
#   end
#
#   def home_loss
#     @games.size { |game| game[:hoa].to_s == 'home' && game[:won].to_s == 'FALSE' }
#   end
#
#   def away_win
#     @games.size { |game| game[:hoa] == 'away' && game[:won] == 'TRUE' }
#   end
#
#   def away_loss
#     @games.size { |game| game[:hoa] == 'away' && game[:won] == 'FALSE' }
#   end
#
#   def best_fans
#     best_fans_team = @combine_data.min_by do |team|
#       total_home = team(home_win) + home_loss
#       total_away = away_win + away_loss
#       (home_win.to_f / total_home) - (away_win.to_f / total_away)
#     end
#      best_fans_team[:team_name]
#   end
#
# def goals_against
#   @combine_data.sum do |game|
#     (game[:away_goals]) if  game[:home_team_id] == :team_id
#     (game[:home_goals]) if  game[:away_team_id] == :tead_id
#   end
# end

# def goals_against
#   @combine_data.sum do |game|
#     if [:team_id] == game[:home_team_id].to_s
#       game[:away_goals]
#     elsif [:team_id] == game[:away_team_id].to_s
#       game[:home_goals]
#     else
#       0
#     end
#   end
# end

# def average_goals_against
#   if games_played.size != 0
#     (goals_against.to_f / games_played.count).round(2)
#   else
#     0.0
#   end
# end

# def goals_against
#   @combine_data.sum do |game|
#     (game[:away_goals]) if  game[:home_team_id] == :team_id
#     (game[:home_goals]) if  game[:away_team_id] == :tead_id
#   end
# end
#
#   def average_goals_against(games)
#     if games_played_in(games).count != 0
#       (goals_against(games).to_f / games_played_in(games).count).round(2)
#     else
#       0.0
#     end
#   end
#
# def games_played
#   @combine_data.find_all { |game| game[:away_team_id].to_s == [:team_id] || game[:home_team_id].to_s == [:team_id] }
# end
#
#   def best_defense
#     found_team = @teams.min_by do |team|
#       team.average_goals_against
#     end
#     return found_team[:team_name]
#   end
# end

#
#   def total_away_points(games)
#     games.sum do |game|
#       if [:team_id].to_s == game[:away_team_id].to_s
#         game[:away_goals]
#       else
#         0
#       end
#     end
#   end
#
#   def total_home_points(games)
#     games.sum do |game|
#       if [:team_id].to_s == game[:home_team_id].to_s
#         game[:home_goals]
#       else
#         0
#       end
#     end
#   end
#
#   def goals_scored(games)
#     total_home_points(games) + total_away_points(games)
#   end
#
#
#   # def games_away(games)
#   #   @games.find_all { |game| game[:away_team_id] == [:team_id] }
#   # end
#   #
#   # def games_home(games)
#   #   @games.find_all { |game| game[:home_team_id] == [:team_id] }
#   # end
#   #
#   # def games_played(games)
#   #   games_away(games) + games_home(games)
#   # end
#
#   # def games_played_in(games)
#   #   games.find_all { |game| game.away_team_id == @team_id || game.home_team_id == @team_id }
#   # end
#
#   # def goals_against(games)
#   #   @games.sum do |game|
#   #     [:team_id] == game[:home_team_id] ||
#   #       [:team_id] == game[:away_team_id]
#   #   end
#   # end
#
#   # def lowest_scoring_visitor
#   #   lowest_scoring_away_team = teams.min_by do |team|
#   #     if team.games_played_as_visitor(games) != 0
#   #       team.total_away_points(games).to_f / team.games_played_as_visitor(games)
#   #     else
#   #       100
#   #     end
#   #   end
#   #   lowest_scoring_away_team.team_name
#   # end
#
#   def games_played_as_visitor
#     @combine_data.count { |game| game[:away_team_id] == [:team_id] }
#   end
# end
#
# def best_defense
#    @teams.min_by { |team| team.average_goals_allowed }.team_name
#  end
#
#  def calculate_season_statistics(teams)
#      teams.each do |team|
#  team.average_goals_allowed = (team.total_goals_allowed.to_f / team.total_games.to_f).round(2)
#
# def calculate_season_statistics(teams)
#     teams.each do |team|
# team.average_away_goals = (team.away_goals_scored.to_f / team.away_games.to_f).round(2)
#
