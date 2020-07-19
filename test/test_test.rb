require "minitest/autorun"

class MyTest < Minitest::Test
    def test_one_plus_one
        assert_equal 2, 1 + 1
    end
end