require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  setup do
  
  end

  test "session should be empty" do
    get "/get_filters"
    assert_response :success
    assert_equal(body, "{}")
  end

  test "add filter to session" do
    param = {'filter_name' => 'test', 'filter_value' => 0, 'filter_label' => 'test'}

    post "/add_filter", params: param
    assert_response :success
    assert_equal(session['test'][0]['value'], "0")
    assert_equal(session['test'][0]['label'], 'test')
  end

end