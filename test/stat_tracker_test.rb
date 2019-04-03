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

end
