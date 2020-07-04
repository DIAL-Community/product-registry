require 'rails_helper'

RSpec.describe "countries/index", type: :view do
  before(:each) do
    assign(:countries, [
      Country.create!(),
      Country.create!()
    ])
  end

  it "renders a list of countries" do
    render
  end
end
