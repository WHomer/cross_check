require './test/test_helper'

class SeasonTest < Minitest::Test
  game_path = './data/game.csv'
  team_path = './data/team_info.csv'
  game_teams_path = './data/game_teams_stats.csv'

  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
  }
  @@stat_tracker = StatTracker.from_csv(locations)

  def test_team_with_biggest_decrease_between_reg_post_season_win_percentage
    assert_equal 'Lightning', @@stat_tracker.biggest_bust('20132014')
    assert_equal 'Jets', @@stat_tracker.biggest_bust('20142015')
  end

  def test_team_with_biggest_increase_between_reg_post_season_win_percentage
    assert_equal 'Kings', @@stat_tracker.biggest_surprise('20132014')
    assert_equal 'Blackhawks', @@stat_tracker.biggest_surprise('20142015')
  end

  def test_coach_with_the_biggest_win_percentage_for_the_season
    assert_equal 'Claude Julien', @stat_tracker.winningest_coach('20132014')
    assert_equal 'Alain Vigneault', @stat_tracker.winningest_coach('20142015')
  end

  def test_coach_with_the_worst_win_percentage_for_the_season
    assert_equal 'Claude Julien', @stat_tracker.worst_coach('20132014')
    assert_equal 'Alain Vigneault', @stat_tracker.worst_coach('20142015')
  end

  def test_team_with_best_ratio_of_shots_to_goals_for_season

  end



end
