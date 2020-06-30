require 'rails_helper'

RSpec.describe "cities/show", type: :view do
  before(:each) do
    @city = assign(:city, City.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
