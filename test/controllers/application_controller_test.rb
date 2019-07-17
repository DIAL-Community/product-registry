class ApplicationControllerTest < ActionView::TestCase
  test "should slug digit only" do
    assert_equal slug_em("1234-5-67 890"), "1234_5_67_890"
  end
end