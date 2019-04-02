require 'csv'
require_relative './game'
require_relative './league'
require_relative './team_statistics'
require_relative './season_statistics'

class StatTracker
  include Game,
          League,
          TeamStatistics,
          SeasonStatistics

  attr_reader :games,
              :teams,
              :game_teams,
              :combine_data

  def initialize(games, teams, game_teams, combine_data)
    @games = games
    @teams = teams
    @game_teams = game_teams
    @combine_data = combine_data
  end

  def self.from_csv(files)
    games = CSV.foreach(files[:games], headers: true, header_converters: :symbol)
    teams = CSV.foreach(files[:teams], headers: true, header_converters: :symbol)
    game_teams = CSV.foreach(files[:game_teams], headers: true, header_converters: :symbol)
    data_sets = combine_data(games, teams, game_teams)

    StatTracker.new(data_sets[:game_data], data_sets[:team_data], data_sets[:game_team_data], data_sets[:all_data])
  end

  def self.combine_data(games, teams, game_teams)
    game_team_data = game_teams.map do |row|
      {"game_id" => row[:game_id],
      "team_id" => row[:team_id],
      "hoa" => row[:HoA],
      "won" => row[:won],
      "settled_in" => row[:settled_in],
      "head_coach" => row[:head_coach],
      "goals" => row[:goals],
      "shots" => row[:shots],
      "hits" => row[:hits],
      "pim" => row[:pim],
      "powerPlayOpportunities" => row[:powerPlayOpportunities],
      "powerPlayGoals" => row[:powerPlayGoals],
      "faceOffWinPercentage" => row[:faceOffWinPercentage],
      "giveaways" => row[:giveaways],
      "takeaways" => row[:takeaways]}
    end
    game_data = games.map do |row|
      {"game_id" => row[:game_id],
       "season" => row[:season],
       "type" => row[:type],
       "date_time" => row[:date_time],
       "away_team_id" => row[:away_team_id],
       "home_team_id" => row[:home_team_id],
       "away_goals" => row[:away_goals],
       "home_goals" => row[:home_goals],
       "outcome" => row[:outcome],
       "home_rink_side_start" => row[:home_rink_side_start],
       "venue" => row[:venue],
       "venue_link" => row[:venue_link],
       "venue_time_zone_id" => row[:venue_time_zone_id],
       "venue_time_zone_offset" => row[:venue_time_zone_offset],
       "venue_time_zone_tz" => row[:venue_time_zone_tz]}
    end
    team_data = teams.map do |row|
      {"team_id" => row[:team_id],
       "franchise_id" => row[:franchiseid],
       "short_name" => row[:shortname],
       "team_name" => row[:teamname],
       "abbreviation" => row[:abbreviation],
       "link" => row[:link]}
    end
    all_data = game_team_data.map do |row|
      team_row = team_data.find{|data| row[:team_id] == data[:team_id]}
      game_row = game_data.find{|data| row[:game_id] == data[:game_id]}
      {"game_id" => row[:game_id],
      "team_id" => row[:team_id],
      "hoa" => row[:HoA],
      "won" => row[:won],
      "settled_in" => row[:settled_in],
      "head_coach" => row[:head_coach],
      "goals" => row[:goals],
      "shots" => row[:shots],
      "hits" => row[:hits],
      "pim" => row[:pim],
      "powerPlayOpportunities" => row[:powerPlayOpportunities],
      "powerPlayGoals" => row[:powerPlayGoals],
      "faceOffWinPercentage" => row[:faceOffWinPercentage],
      "giveaways" => row[:giveaways],
      "takeaways" => row[:takeaways],
      "franchise_id" => team_row[:franchiseid],
      "short_name" => team_row[:shortname],
      "team_name" => team_row[:teamname],
      "abbreviation" => team_row[:abbreviation],
      "link" => team_row[:team_link],
      "season" => game_row[:season],
      "type" => game_row[:type],
      "date_time" => game_row[:date_time],
      "away_team_id" => game_row[:away_team_id],
      "home_team_id" => game_row[:home_team_id],
      "away_goals" => game_row[:away_goals],
      "home_goals" => game_row[:home_goals],
      "outcome" => game_row[:outcome],
      "home_rink_side_start" => game_row[:home_rink_side_start],
      "venue" => game_row[:venue],
      "venue_link" => game_row[:venue_link],
      "venue_time_zone_id" => game_row[:venue_time_zone_id],
      "venue_time_zone_offset" => game_row[:venue_time_zone_offset],
      "venue_time_zone_tz" => game_row[:venue_time_zone_tz]}
    end
    # puts game_team_data.select { |record| record[:head_coach] == "Mike Babcock" }
    # puts game_team_data.inject(0) {|sum, hash| sum + hash[:goals]}
    return {game_team_data: game_team_data,
            game_data: game_data,
            team_data: team_data,
            all_data: all_data}
  end
end
