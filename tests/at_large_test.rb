require_relative '../lib/at_large'
require 'test/unit'
include AtLarge

class TestAtLarge < Test::Unit::TestCase
  def test_median
    expected = median((1..10).to_a)
    assert_equal expected, 5.5, 'AtLarge#median fail'
  end

  def test_ie
    %w{tp ld}.each do |abbr|
      assert !ie?(abbr), 'AtLarge#ie? fail'
    end
  end

  def test_advancing
    tests = {
      16 => [0,  8],
      7  => [0,  4],
      29 => [14, 8],
      70 => [24, 8]
    }
    tests.each { |k ,v| assert_equal advancing(k), v, 'AtLarge#advancing fail' }
  end

  def test_find_standings

  end
end