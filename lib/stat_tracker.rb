require 'csv'

class StatTracker

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(files)

    games = CSV.foreach(files[:games], headers: true, header_converters: :symbol)
    teams = CSV.foreach(files[:teams], headers: true, header_converters: :symbol)
    game_teams = CSV.foreach(files[:game_teams], headers: true, header_converters: :symbol)

    StatTracker.new(games, teams, game_teams)
  end

end
