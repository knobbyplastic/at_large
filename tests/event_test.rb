require_relative '../lib/event'
require 'test/unit'

class EventTest < Test::Unit::TestCase
  def test_finalists
    expected = Event.new('WI Qual.', 'ads', 26).finalists
    assert_equal expected, 8, 'Event#finalists fail'
  end
end