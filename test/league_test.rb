require 'minitest/autorun'
require 'minitest/emoji'
require './lib/stat_tracker'


class LeagueTest < Minitest::Test
  game_path = './data/game.csv'
  team_path = './data/team_info.csv'
  game_teams_path = './data/game_teams_stats.csv'

  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
  }
  @@stat_tracker = StatTracker.from_csv(locations)

  def test_the_total_number_of_teams_in_data_set
    assert_equal 33, @@stat_tracker.count_of_teams
  end
#
#   def test_the_team_with_the_best_offense
#     assert_equal 'Golden Knights', @@stat_tracker.best_offense
#   end
#
  def test_the_team_with_the_worst_offense
    assert_equal 'Sabres', @@stat_tracker.worst_offense
  end

#   def test_the_team_with_best_defense
#     assert_equal 'Kings', @@stat_tracker.best_defense
#   end
#
#   def test_the_team_with_worst_defense
#     assert_equal 'Coyotes', @@stat_tracker.worst_defense
#   end
#
  def test_team_with_highest_average_score_when_team_is_a_visitor
    assert_equal 'Capitals', @@stat_tracker.highest_scoring_visitor
  end

  def test_team_with_highest_average_score_when_team_is_at_home
    assert_equal 'Golden Knights', @@stat_tracker.highest_scoring_home_team
  end

  def test_team_with_lowest_average_score_when_team_is_a_visitor
    assert_equal 'Sabres', @@stat_tracker.lowest_scoring_visitor
  end
#
#   def test_team_with_lowest_average_score_when_team_is_at_home
#     assert_equal 'Sabres', @@stat_tracker.lowest_scoring_home_team
#   end
#
#   def test_team_with_highest_win_percentage_across_all_seasons
#     assert_equal 'Golden Knights', @@stat_tracker.winningest_team
#   end
#
#   def test_team_with_biggest_difference_between_home_and_away_wins
#     assert_equal 'Coyotes', @@stat_tracker.best_fans
#   end
#
#   def test_number_of_home_wins
#     assert_equal 7441, @@stat_tracker.home_win
#   end
#
#   def test_number_of_home_losses
#     assert_equal 7441, @@stat_tracker.home_loss
#   end
#
#   def test_number_of_away_wins
#     assert_equal 7441, @@stat_tracker.away_win
#   end
#
#   def test_number_of_away_losses
#     assert_equal 7441, @@stat_tracker.away_loss
#   end
#
#   def test_games_played_in
#     assert_equal [], @@stat_tracker.games_played
#   end
#
#   def test_goals_against
#     assert_equal 0, @@stat_tracker.goals_against
#   end
#
#   def test_average_goals_against
#     assert_equal 0.0, @@stat_tracker.average_goals_against
#   end
#
#   def test_teams_with_better_away_records_than_home_records
#     assert_equal [], @@stat_tracker.worst_fans
#   end
#
#   def test_goals_allowed
#     assert_equal 3, @@stat_tracker.goals_allowed
#   end
end
