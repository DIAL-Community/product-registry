require 'rails_helper'

RSpec.describe "countries/new", type: :view do
  before(:each) do
    assign(:country, Country.new())
  end

  it "renders new country form" do
    render

    assert_select "form[action=?][method=?]", countries_path, "post" do
    end
  end
end
