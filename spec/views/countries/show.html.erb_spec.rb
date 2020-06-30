require 'rails_helper'

RSpec.describe "countries/show", type: :view do
  before(:each) do
    @country = assign(:country, Country.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
