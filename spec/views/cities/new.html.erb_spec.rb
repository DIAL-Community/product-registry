require 'rails_helper'

RSpec.describe "cities/new", type: :view do
  before(:each) do
    assign(:city, City.new())
  end

  it "renders new city form" do
    render

    assert_select "form[action=?][method=?]", cities_path, "post" do
    end
  end
end
