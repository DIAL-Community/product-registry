require 'rails_helper'

RSpec.describe "category_indicators/show", type: :view do
  before(:each) do
    @category_indicator = assign(:category_indicator, CategoryIndicator.create!(
      name: "Name",
      slug: "Slug",
      weight: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/9.99/)
  end
end
