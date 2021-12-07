FactoryBot.define do
  factory :product_repository do
    name { "MyString" }
    description { "MyString" }
    main_repository { false }
    dpga_data { "" }
    language_data { "" }
    statistical_information { "" }
    license_information { "" }
    license { "MyString" }
    code_lines { 1 }
    cocomo { 1 }
    est_hosting { 1 }
    est_invested { 1 }
  end
end
