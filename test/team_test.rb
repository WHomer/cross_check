require './test/test_helper'

class TeamTest < Minitest::Test
  game_path = './data/game.csv'
  team_path = './data/team_info.csv'
  game_teams_path = './data/game_teams_stats.csv'

  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
  }
  @@stat_tracker = StatTracker.from_csv(locations)

  def test_it_returns_a_hash_of_team_info_for_each_team
    expected = {
      'team_id' => '18',
      'franchise_id' => '34',
      'short_name' => 'Nashville',
      'team_name' => 'Predators',
      'abbreviation' => 'NSH',
      'link' => '/api/v1/teams/18'
    }
    actual = @@stat_tracker.team_info(18)
    assert_equal expected, actual
  end

  def test_season_with_the_highest_win_percentage_for_a_team
    assert_equal '20132014', @@stat_tracker.best_season('6')
  end

  def test_season_with_the_lowest_win_percentage_for_a_team
    assert_equal '20142015', @@stat_tracker.worst_season('6')
  end

  def test_average_win_percentage_of_all_games_for_a_team
    assert_equal 0.52, @@stat_tracker.average_win_percentage('18')
  end

  def test_team_with_highest_number_of_goals_in_a_game
    assert_equal 9, @@stat_tracker.most_goals_scored('18')
  end

  def test_team_with_lowest_number_of_goals_in_a_game
    assert_equal 0, @@stat_tracker.fewest_goals_scored('18')
  end

  def test_name_of_team_with_lowest_win_percentage_against_given_team
    assert_equal 'Oilers', @@stat_tracker.favorite_opponent('18')
  end

  def test_name_of_team_with_higest_win_percentage_against_given_team
    assert_equal 'Red Wings', @@stat_tracker.rival('18')
  end




end
