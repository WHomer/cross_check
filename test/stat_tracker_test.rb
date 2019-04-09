require './test/test_helper'

class StatTrackerTest < Minitest::Test
  game_path = './data/game.csv'
  team_path = './data/team_info.csv'
  game_teams_path = './data/game_teams_stats.csv'

  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
  }
  @@stat_tracker = StatTracker.from_csv(locations)

  def test_it_exists
    assert_instance_of StatTracker, @@stat_tracker
  end

  def test_game_has_highest_total_score
    assert_equal 15, @@stat_tracker.highest_total_score
  end

  def test_the_total_number_of_teams_in_data_set
    assert_equal 33, @@stat_tracker.count_of_teams
  end

  # def test_it_returns_a_hash_of_team_info_for_each_team
  #   expected = {
  #     "team_id" => "18",
  #     "franchise_id" => "34",
  #     "short_name" => "Nashville",
  #     "team_name" => "Predators",
  #     "abbreviation" => "NSH",
  #     "link" => "/api/v1/teams/18"
  #   }
  #   actual = @@stat_tracker.team_info(18)
  #   assert_equal expected, actual
  # end

  def test_biggest_blowout #game test
   assert_equal 10, @@stat_tracker.biggest_blowout
  end

  def test_game_has_lowest_total_score
    assert_equal 1, @@stat_tracker.lowest_total_score
  end

  def test_percentage_visitor_wins #game test
    assert_equal 0.45, @@stat_tracker.percentage_visitor_wins
  end

  def test_percentage_home_wins
    assert_equal 0.55, @@stat_tracker.percentage_home_wins
  end

  def test_average_goals_by_season
      expected = {
        "20122013"=>5.4,
        "20162017"=>5.51,
        "20142015"=>5.43,
        "20152016"=>5.41,
        "20132014"=>5.5,
        "20172018"=>5.94
      }
      assert_equal expected, @@stat_tracker.average_goals_by_season
  end

  def test_count_of_games_by_season
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }
    assert_equal expected, @@stat_tracker.count_of_games_by_season
  end

  def test_biggest_bust
    assert_equal 'Lightning', @@stat_tracker.biggest_bust("20132014")
  end

  def test_worst_loss
    assert_equal 6, @@stat_tracker.worst_loss("18")
  end

  def test_highest_scoring_visitor
    assert_equal 'Capitals',@@stat_tracker.highest_scoring_visitor
  end

  def test_biggest_surprise
    assert_equal 'Blackhawks', @@stat_tracker.biggest_surprise('20142015')
  end

  def test_worst_offense
    assert_equal 'Sabres', @@stat_tracker.worst_offense
  end

  def test_worst_fans
    assert_equal [], @@stat_tracker.worst_fans
  end

  def test_favorite_opponent
    assert_equal 'Oilers', @@stat_tracker.favorite_opponent('18')
  end

  def test_average_win_percentage
    assert_equal 0.52, @@stat_tracker.average_win_percentage("18")
  end

  def test_most_accurate_team
    assert_equal "Ducks", @@stat_tracker.most_accurate_team("20132014")
  end
  def test_average_goals_per_game #game test
    assert_equal 5.54, @@stat_tracker.average_goals_per_game
  end

  def test_best_offense #game_test
    assert_equal "Golden Knights", @@stat_tracker.best_offense
  end

  def test_highest_scoring_home_team # league
    assert_equal "Golden Knights", @@stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team # league
    assert_equal "Sabres", @@stat_tracker.lowest_scoring_home_team
  end

  def test_worst_defense # game
    assert_equal "Coyotes", @@stat_tracker.worst_defense
  end

  def test_best_defense # game
    assert_equal "Kings", @@stat_tracker.best_defense
  end

  def test_winningest_team #game
    assert_equal "Golden Knights", @@stat_tracker.winningest_team
  end

  # def test_most_goals_scored
  #   assert_equal 9, @@stat_tracker.most_goals_scored("18")
  # end

end
