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
    assert_equal 0.52, @@stat_tracker.worst_season('18')
  end

  end



  end

  end


end
