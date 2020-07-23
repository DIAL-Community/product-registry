require 'test_helper'
require 'modules/maturity_sync'

class ProductTest < ActiveSupport::TestCase
  include Modules::MaturitySync

  test 'should calculate maturity_scores' do
    rubric = maturity_rubrics(:two)

    # product one does not have any maturity data
    product2 = products(:one)
    maturity_scores = calculate_maturity_scores(product2.id, rubric.id)[:rubric_scores].first[:category_scores].first[:indicator_scores]
    assert_equal maturity_scores.first[:score], 0

    # product three shouold have a value of true for the indicator (score should be 10)
    product3 = products(:three)
    maturity_scores = calculate_maturity_scores(product3.id, rubric.id)[:rubric_scores].first[:category_scores].first[:indicator_scores]
    assert_equal maturity_scores.first[:score], 10
  end

end
