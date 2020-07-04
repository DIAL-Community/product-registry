require 'rails_helper'

RSpec.describe "cities/index", type: :view do
  before(:each) do
    assign(:cities, [
      City.create!(),
      City.create!()
    ])
  end

  it "renders a list of cities" do
    render
  end
end
