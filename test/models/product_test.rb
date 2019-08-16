require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'should calculate digisquare maturity_scores' do
    product = products(:one)
    maturity_scores = product.maturity_scores

    # Should only have the digisquare keys.
    assert_equal maturity_scores.keys.count, 3
    assert_equal maturity_scores['Global Utility'], 7
    assert_equal maturity_scores['Community Support'], 5
    assert_equal maturity_scores['Software Maturity'], 5
  end

  test 'should calculate osc maturity_score' do
    product = products(:two)
    maturity_scores = product.maturity_scores

    # Should have all of the osc keys.
    assert_equal maturity_scores.keys.count, 8
    assert_equal maturity_scores['Software Code']['score'], 1
    assert_equal maturity_scores['Licenses and Copyright']['score'], 0
    assert_equal maturity_scores['Software Releases']['score'], 0
    assert_equal maturity_scores['Software Quality']['score'], 2
    assert_equal maturity_scores['Community']['score'], 1
    assert_equal maturity_scores['Consensus Building']['score'], 0
    assert_equal maturity_scores['Independence']['score'], 0
    assert_equal maturity_scores['Impact']['score'], 0
  end

  test 'should calculate both maturity_score' do
    product = products(:three)
    maturity_scores = product.maturity_scores

    # Should have both have the digisquare keys and the osc keys.
    assert_equal maturity_scores.keys.count, 11
    assert_equal maturity_scores['Global Utility'], 5
    assert_equal maturity_scores['Community Support'], 5
    assert_equal maturity_scores['Software Maturity'], 5

    assert_equal maturity_scores['Software Code']['score'], 1
    assert_equal maturity_scores['Licenses and Copyright']['score'], 0
    assert_equal maturity_scores['Software Releases']['score'], 0
    assert_equal maturity_scores['Software Quality']['score'], 0
    assert_equal maturity_scores['Community']['score'], 0
    assert_equal maturity_scores['Consensus Building']['score'], 0
    assert_equal maturity_scores['Independence']['score'], 0
    assert_equal maturity_scores['Impact']['score'], 0
  end
end
