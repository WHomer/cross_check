require 'minitest/autorun'
require 'minitest/emoji'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    @stat_tracker = StatTracker.new

  end

  def test_it_exists

    assert_instance_of StatTracker, @stat_tracker
  end

end
