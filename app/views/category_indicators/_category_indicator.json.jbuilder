json.extract!(category_indicator, :id, :name, :slug, :indicator_type, :weight, :source_indicator,
              :data_source, :created_at, :updated_at)
json.url(maturity_rubric_rubric_category_category_indicator_url(category_indicator.rubric_category.maturity_rubric,
                                                                category_indicator.rubric_category,
                                                                category_indicator, format: :json))
