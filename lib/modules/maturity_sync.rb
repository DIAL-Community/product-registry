module Modules
  module MaturitySync
    def create_category(cat_name, maturity_rubric) 
      category_slug = slug_em(cat_name)
      rubric_category = RubricCategory.where(maturity_rubric_id: maturity_rubric.id, slug: category_slug)
                                                    .first || RubricCategory.new
      rubric_category.name = cat_name
      rubric_category.slug = category_slug
      rubric_category.maturity_rubric = maturity_rubric
      rubric_category.weight = 1.0
      rubric_category.save!

      rubric_category_desc = RubricCategoryDescription.where(rubric_category_id: rubric_category.id, locale: I18n.locale)
                                                      .first || RubricCategoryDescription.new
      rubric_category_desc.rubric_category_id = rubric_category.id
      rubric_category_desc.locale = I18n.locale
      rubric_category_desc.description_html = '<p>'+cat_name+'</p>'
      rubric_category_desc.description = {}
      rubric_category_desc.save

      rubric_category
    end

    def create_indicator(indicator_name, indicator_desc, indicator_source, indicator_count, indicator_type, category_id) 
      indicator_slug = slug_em(indicator_name)
      category_indicator = CategoryIndicator.where(rubric_category_id: category_id, slug: indicator_slug)
                                                    .first || CategoryIndicator.new
      category_indicator.name = indicator_name
      category_indicator.slug = indicator_slug
      category_indicator.rubric_category_id = category_id
      category_indicator.data_source = indicator_source
      category_indicator.weight = (100.0 / indicator_count.to_f).round / 100.0
      category_indicator.source_indicator = indicator_name
      category_indicator.indicator_type = CategoryIndicator.category_indicator_types.key(indicator_type.downcase)
      category_indicator.save!

      category_indicator_desc = CategoryIndicatorDescription.where(category_indicator_id: category_indicator.id, locale: I18n.locale)
                                                      .first || CategoryIndicatorDescription.new
      category_indicator_desc.category_indicator_id = category_indicator.id
      category_indicator_desc.locale = I18n.locale
      category_indicator_desc.description_html = '<p>'+indicator_desc+'</p>'
      category_indicator_desc.description = {}
      category_indicator_desc.save
    end

    def calculate_maturity_scores(product_id, rubric_id = nil)
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO

      product_indicators = ProductIndicator.where('product_id = ?', product_id)
                                          .map { |indicator| { indicator.category_indicator_id.to_s => indicator.indicator_value } }

      product_indicators = product_indicators.reduce Hash.new, :merge

      product_score = { rubric_scores: [] }

      if rubric_id.nil?
        maturity_rubrics = MaturityRubric.all
      else
        maturity_rubrics = MaturityRubric.where(id: rubric_id)
      end

      maturity_rubrics.each do |maturity_rubric|
        rubric_score = {
          id: maturity_rubric.id,
          name: maturity_rubric.name,
          category_scores: [],
          indicator_count: 0,
          # Number of indicator without score at the rubric level.
          missing_score: 0,
          # Overall score at the rubric level
          overall_score: 0
        }

        rubric_categories = RubricCategory.where(maturity_rubric: maturity_rubric).includes(:rubric_category_descriptions)
        rubric_categories.each do |rubric_category|
          category_description = rubric_category.rubric_category_descriptions.first
          category_score = {
            id: rubric_category.id,
            name: rubric_category.name,
            weight: rubric_category.weight,
            description: !category_description.nil? && category_description.description_html.gsub(/<\/?[^>]*>/, ''),
            indicator_scores: [],
            # Number of indicator without score at the category level.
            missing_score: 0,
            # Overall score at the category level
            overall_score: 0
          }
          category_indicators = CategoryIndicator.where(rubric_category: rubric_category).includes(:category_indicator_descriptions)
          category_indicators.each do |category_indicator|
            indicator_value = product_indicators[category_indicator.id.to_s]
            indicator_type = category_indicator.indicator_type
            indicator_description = category_indicator.category_indicator_descriptions.first

            indicator_score = {
              id: category_indicator.id,
              name: category_indicator.name,
              weight: category_indicator.weight,
              description: !indicator_description.nil? && indicator_description.description_html.gsub(/<\/?[^>]*>/, ''),
              score: convert_to_numeric(indicator_value, indicator_type, category_indicator.weight)
            }

            if indicator_score[:score].nil?
              category_score[:missing_score] += 1
            else
              category_score[:overall_score] += indicator_score[:score]
            end
            category_score[:indicator_scores] << indicator_score
          end

          # Occasionally, rounding errors can lead to a score > 10
          if category_score[:overall_score] > 10
            category_score[:overall_score] = 10.0
          end
          rubric_score[:indicator_count] += category_score[:indicator_scores].count
          rubric_score[:missing_score] += category_score[:missing_score]
          rubric_score[:overall_score] += category_score[:overall_score]
          rubric_score[:category_scores] << category_score
        end

        # Now do final score calculation
        total_categories = 0
        rubric_score[:category_scores].each do |category|
          if category[:overall_score] > 0 
            total_categories += 1
          end
        end
        if total_categories > 0
          rubric_score[:overall_score] = rubric_score[:overall_score]*10/total_categories
        end
        product_score[:rubric_scores] << rubric_score
      end

      logger.debug("Rubric score for product: #{product_id} is: #{product_score.to_json}")
      product_score
    end

    def convert_to_numeric(score, type, weight)
      numeric_value = nil
      return numeric_value if score.nil?
  
      if type == 'boolean'
        if score == 'true' || score == 't'
          numeric_value = 10.0 * weight
        end
      elsif type == 'scale'
        if score == 'medium'
          numeric_value = 5.0 * weight
        elsif score == 'high'
          numeric_value = 10.0 * weight
        end
      elsif type == 'numeric'
        numeric_value = score.to_f * weight
      end
      numeric_value
    end
  end
end
