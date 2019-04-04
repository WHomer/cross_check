require 'minitest/autorun'
require 'minitest/emoji'
require './lib/stat_tracker'
require "pry"

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

  def test_it_returns_a_hash_of_team_info_for_each_team
    expected = {
      "team_id" => "18",
      "franchise_id" => "34",
      "short_name" => "Nashville",
      "team_name" => "Predators",
      "abbreviation" => "NSH",
      "link" => "/api/v1/teams/18"
    }
    actual = @@stat_tracker.team_info(18)
    assert_equal expected, actual
  end

  def test_biggest_blowout
   assert_equal 10, @@stat_tracker.biggest_blowout
  end

  def test_game_has_lowest_total_score
    assert_equal 1, @@stat_tracker.lowest_total_score
  end

  def test_percentage_visitor_wins
    assert_equal 0.45, @@stat_tracker.percentage_visitor_wins
  end

  def test_percentage_home_wins
    assert_equal 0.55, @@stat_tracker.percentage_home_wins
  end

  def test_average_goals_by_season
    skip
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

end
