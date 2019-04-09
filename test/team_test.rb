require 'minitest/autorun'
require 'minitest/emoji'
require './lib/stat_tracker'

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
  #
  # def test_average_win_percentage_of_all_games_for_a_team
  #   assert_equal 0.52, @@stat_tracker.average_win_percentage('18')
  # end
  #
  # def test_team_with_highest_number_of_goals_in_a_game
  #   assert_equal 9, @@stat_tracker.most_goals_scored('18')
  # end
  #
  def test_team_with_lowest_number_of_goals_in_a_game
    assert_equal 0, @@stat_tracker.fewest_goals_scored('18')
  end
  #
  def test_name_of_team_with_lowest_win_percentage_against_given_team
    assert_equal 'Oilers', @@stat_tracker.favorite_opponent('18')
  end

  def test_name_of_team_with_higest_win_percentage_against_given_team
    assert_equal 'Red Wings', @@stat_tracker.rival('18')
  end

  def test_biggest_diff_between_goals_scored_for_a_win
    assert_equal 7, @@stat_tracker.biggest_team_blowout('18')
  end
  #
  # def test_biggest_diff_between_goals_scored_for_a_loss
  #   assert_equal 6, @@stat_tracker.worst_loss('18')
  # end

  def test_record_against_all_opponents_win_percentages
    expected = {
      'Blues' => 0.47,
      'Jets' => 0.55,
      'Avalanche' => 0.63,
      'Flames' => 0.44,
      'Red Wings' => 0.29,
      'Blue Jackets' => 0.6,
      'Stars' => 0.52,
      'Blackhawks' => 0.42,
      'Wild' => 0.44,
      'Devils' => 0.5,
      'Canadiens' => 0.6,
      'Canucks' => 0.5,
      'Rangers' => 0.4,
      'Lightning' => 0.7,
      'Capitals' => 0.7,
      'Sharks' => 0.6,
      'Oilers' => 0.78,
      'Ducks' => 0.48,
      'Penguins' => 0.31,
      'Islanders' => 0.4,
      'Kings' => 0.61,
      'Sabres' => 0.7,
      'Coyotes' => 0.67,
      'Bruins' => 0.5,
      'Panthers' => 0.5,
      'Maple Leafs' => 0.4,
      'Senators' => 0.7,
      'Hurricanes' => 0.3,
      'Golden Knights' => 0.33,
      'Flyers' => 0.5
    }

    assert_equal expected, @@stat_tracker.head_to_head(18)
  end

  # def test_season_summary_for_each_team
  #   expected = {
  #    '20162017' => {
  #      postseason: {
  #        :win_percentage=>0.64,
  #        :total_goals_scored=>60,
  #        :total_goals_against=>48,
  #        :average_goals_scored=>2.73,
  #        :average_goals_against=>2.18},
  #        :regular_season => {
  #          :win_percentage=>0.5,
  #          :total_goals_scored=>240,
  #          :total_goals_against=>224,
  #          :average_goals_scored=>2.93,
  #          :average_goals_against=>2.73
  #        }
  #      },
  #      '20172018' => {
  #        postseason: {
  #          :win_percentage=>0.54,
  #          :total_goals_scored=>41,
  #          :total_goals_against=>42,
  #          :average_goals_scored=>3.15,
  #          :average_goals_against=>3.23
  #        },
  #        :regular_season=>
  #        {:win_percentage=>0.65,
  #          :total_goals_scored=>267,
  #          :total_goals_against=>211,
  #          :average_goals_scored=>3.26,
  #          :average_goals_against=>2.57
  #        }
  #      },
  #      '20132014' => {
  #        postseason: {
  #          :win_percentage=>0.0,
  #          :total_goals_scored=>0,
  #          :total_goals_against=>0,
  #          :average_goals_scored=>0.0,
  #          :average_goals_against=>0.0
  #        },
  #        :regular_season=>
  #        {
  #          :win_percentage=>0.46,
  #          :total_goals_scored=>216,
  #          :total_goals_against=>242,
  #          :average_goals_scored=>2.63,
  #          :average_goals_against=>2.95
  #        }
  #      },
  #      '20122013' => {
  #        postseason: {
  #          :win_percentage=>0.0,
  #          :total_goals_scored=>0,
  #          :total_goals_against=>0,
  #          :average_goals_scored=>0.0,
  #          :average_goals_against=>0.0
  #        },
  #        :regular_season=>
  #        {
  #          :win_percentage=>0.33,
  #          :total_goals_scored=>111,
  #          :total_goals_against=>139,
  #          :average_goals_scored=>2.31,
  #          :average_goals_against=>2.9
  #        }
  #      },
  #      '20142015' => {
  #        postseason: {
  #          :win_percentage=>0.33,
  #          :total_goals_scored=>21,
  #          :total_goals_against=>19,
  #          :average_goals_scored=>3.5,
  #          :average_goals_against=>3.17
  #        },
  #        :regular_season=>
  #        {
  #          :win_percentage=>0.57,
  #          :total_goals_scored=>232,
  #          :total_goals_against=>208,
  #          :average_goals_scored=>2.83,
  #          :average_goals_against=>2.54
  #        }
  #      },
  #      '20152016' => {
  #        postseason: {
  #          :win_percentage=>0.5,
  #          :total_goals_scored=>31,
  #          :total_goals_against=>43,
  #          :average_goals_scored=>2.21,
  #          :average_goals_against=>3.07
  #        },
  #        :regular_season=>
  #        {
  #          :win_percentage=>0.5,
  #          :total_goals_scored=>228,
  #          :total_goals_against=>215,
  #          :average_goals_scored=>2.78,
  #          :average_goals_against=>2.62
  #        }
  #      }
  #    }
  #    actual = @@stat_tracker.seasonal_summary(18)
  #   assert_equal expected, actual
  # end
end
