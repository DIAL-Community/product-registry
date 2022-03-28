# frozen_string_literal: true

require 'modules/slugger'
require 'modules/maturity_sync'
require 'kramdown'
require 'nokogiri'

namespace :maturity_sync do
  include Modules::Slugger
  include Modules::MaturitySync
  include Kramdown
  include Nokogiri

  task :sync_data, [:path] => :environment do |_, params|
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG

    if MaturityRubric.default_maturity_rubric.nil?
      logger.debug('Default maturity rubric configuration is not found. Please run db:seed first.')
      next
    end

    data = File.read(File.join(params[:path], 'README.md'))
    html_md = Kramdown::Document.new(data).to_html
    html_fragment = Nokogiri::HTML.fragment(html_md)

    document_header = html_fragment.at_css('h1')
    logger.debug("Rubric Header: #{document_header.inner_html}")

    maturity_rubric = MaturityRubric.find_by(slug: MaturityRubric.default_maturity_rubric) || MaturityRubric.new
    maturity_rubric.name = document_header.inner_html
    maturity_rubric.slug = MaturityRubric.default_maturity_rubric
    maturity_rubric.save!

    description = ''
    current_node = document_header.next_sibling
    until current_node.nil?
      description += current_node.to_html
      description += '<br />' unless current_node.to_html.blank?
      current_node = current_node.next_sibling
    end

    maturity_rubric_desc = MaturityRubricDescription.where(maturity_rubric_id: maturity_rubric.id, locale: I18n.locale)
                                                    .first || MaturityRubricDescription.new
    maturity_rubric_desc.maturity_rubric_id = maturity_rubric.id
    maturity_rubric_desc.locale = I18n.locale
    maturity_rubric_desc.description = description
    maturity_rubric_desc.save!

    Dir.glob("#{params[:path]}/categories/*.md").each do |category_page|
      next if category_page.include?('sources')

      data = File.read(category_page)
      html_md = Kramdown::Document.new(data).to_html
      html_fragment = Nokogiri::HTML.fragment(html_md)

      document_header = html_fragment.at_css('h1')
      logger.debug("Category Header: #{document_header.inner_html}")

      category_name = document_header.inner_html
      category_slug = slug_em(category_name)

      duplicate_categories = RubricCategory.where(slug: category_slug)
                                           .order(slug: :desc)

      rubric_category = nil
      if duplicate_categories.count.positive?
        first_duplicate = duplicate_categories.first
        if first_duplicate.maturity_rubric_id == maturity_rubric.id
          # It's not a duplicate, so we should update this record.
          rubric_category = first_duplicate
          rubric_category.name = category_name
          logger.debug("Existing category found: #{rubric_category.slug}.")
        else
          # It's a duplicate because it's belong to a separate rubric.
          # Calculate the offset.
          dupe = RubricCategory.slug_starts_with(category_slug)
                               .order(slug: :desc)
                               .first
          size = 1
          unless dupe.nil?
            size = dupe.slug
                       .slice(/_dup\d+$/)
                       .delete('^0-9')
                       .to_i + 1
          end
          rubric_category = RubricCategory.new
          rubric_category.name = category_name
          rubric_category.slug = "#{category_slug}_dup#{size}"
          logger.debug("Creating duplicate category: #{rubric_category.slug}.")
        end
      else
        rubric_category = RubricCategory.new
        rubric_category.name = category_name
        rubric_category.slug = category_slug
        logger.debug("Creating new category: #{rubric_category.slug}.")
      end
      rubric_category.maturity_rubric = maturity_rubric
      rubric_category.weight = 1.0
      rubric_category.save!

      description = ''
      current_node = document_header.next_sibling
      until current_node.name == 'h2' && current_node.text == 'Indicators'
        description += current_node.to_html
        description += '<br />' unless current_node.to_html.blank?
        current_node = current_node.next_sibling
      end

      rubric_category_desc = RubricCategoryDescription.where(rubric_category_id: rubric_category.id,
                                                             locale: I18n.locale)
                                                      .first || RubricCategoryDescription.new
      rubric_category_desc.rubric_category_id = rubric_category.id
      rubric_category_desc.locale = I18n.locale
      rubric_category_desc.description = description
      rubric_category_desc.save

      indicators = html_fragment.css('tbody > tr')
      next if indicators.size <= 0

      indicators.each do |indicator|
        current_part = indicator.at_css('td')
        indicator_name = current_part.inner_html

        current_part = current_part.next_element
        indicator_source = current_part.inner_html

        current_part = current_part.next_element
        description_html = current_part.inner_html

        current_part = current_part.next_element
        indicator_type = current_part.inner_html

        indicator_slug = slug_em(indicator_name)
        duplicate_indicators = CategoryIndicator.where(slug: indicator_slug)
                                                .order(slug: :desc)

        if duplicate_indicators.count.positive?
          first_duplicate = duplicate_indicators.first
          if first_duplicate.rubric_category_id == rubric_category.id
            # It's not a duplicate, so we should update this record.
            category_indicator = first_duplicate
            category_indicator.name = indicator_name
            logger.debug("Existing indicator found: #{category_indicator.slug}.")
          else
            # It's a duplicate because it's belong to a separate rubric.
            # Calculate the offset.

            dupe = CategoryIndicator.slug_starts_with(indicator_slug)
                                    .order(slug: :desc)
                                    .first
            size = 1
            unless dupe.nil?
              size = dupe.slug
                         .slice(/_dup\d+$/)
                         .delete('^0-9')
                         .to_i + 1
            end
            category_indicator = CategoryIndicator.new
            category_indicator.name = indicator_name
            category_indicator.slug = "#{indicator_slug}_dup#{size}"
            logger.debug("Creating duplicate indicator: #{category_indicator.slug}.")
          end
        else
          category_indicator = CategoryIndicator.new
          category_indicator.name = indicator_name
          category_indicator.slug = indicator_slug
          logger.debug("Creating new indicator: #{category_indicator.slug}.")
        end

        category_indicator.rubric_category = rubric_category
        category_indicator.data_source = indicator_source
        category_indicator.weight = (100.0 / indicators.count.to_f).round / 100.0
        category_indicator.source_indicator = indicator_name
        category_indicator.indicator_type = CategoryIndicator.category_indicator_types.key(indicator_type.downcase)
        category_indicator.save!

        category_indicator_desc = CategoryIndicatorDescription.where(category_indicator_id: category_indicator.id,
                                                                     locale: I18n.locale)
                                                              .first || CategoryIndicatorDescription.new
        category_indicator_desc.category_indicator_id = category_indicator.id
        category_indicator_desc.locale = I18n.locale
        category_indicator_desc.description = description_html
        category_indicator_desc.save
      end
    end
  end

  task :sync_legacy, [:path] => :environment do |_, _params|
    maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric') || MaturityRubric.new
    maturity_rubric.name = 'Legacy Rubric'
    maturity_rubric.slug = 'legacy_rubric'
    maturity_rubric.save!

    maturity_rubric_desc = MaturityRubricDescription.where(maturity_rubric_id: maturity_rubric.id, locale: I18n.locale)
                                                    .first || MaturityRubricDescription.new
    maturity_rubric_desc.maturity_rubric_id = maturity_rubric.id
    maturity_rubric_desc.locale = I18n.locale
    maturity_rubric_desc.description = '<p>The legacy rubric tracks maturity data from OSC and Digital Square data sources.</p>'
    maturity_rubric_desc.save!

    digisquare_maturity = YAML.load_file('config/maturity_digisquare.yml')
    digisquare_maturity.each do |digi_category|
      rubric_category = create_category(digi_category['core'], maturity_rubric)

      category_count = digi_category['sub-indicators'].count
      digi_category['sub-indicators'].each do |indicator|
        puts "CATEGORY: #{digi_category['core']} INDICATOR: #{indicator['name']}"
        cat_indicator = create_indicator(indicator['name'], indicator['name'], 'Digital Square', category_count,
                                         'scale', rubric_category.id)
      end
    end

    osc_maturity = YAML.load_file('config/maturity_osc.yml')
    osc_maturity.each do |osc_category|
      rubric_category = create_category(osc_category['header'], maturity_rubric)

      category_count = osc_category['items'].count
      osc_category['items'].each do |indicator|
        puts "CATEGORY: #{osc_category['header']} INDICATOR: #{indicator['code']}"
        cat_indicator = create_indicator(indicator['code'], indicator['desc'], 'DIAL OSC', category_count, 'boolean',
                                         rubric_category.id)
      end
    end
  end

  task :update_maturity_scores, [:path] => :environment do |_, _params|
    # Note, we are going to use the legacy rubric for now. Eventually, we will want to set this
    # to the default rubric
    maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
    Product.all.each do |product|
      product_indicators = ProductIndicator.where(product_id: product.id)
      next unless product_indicators.any?

      puts "UPDATING SCORE FOR: #{product.name}"
      maturity_score = calculate_maturity_scores(product.id, maturity_rubric.id)
      overall_score = maturity_score[:rubric_scores][0][:overall_score].to_i
      puts "OVERALL SCORE: #{overall_score}"
      product.maturity_score = overall_score
      product.save!
    end
  end
end
