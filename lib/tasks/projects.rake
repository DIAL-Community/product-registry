require "fileutils"
require 'modules/projects'

include Modules::Projects

namespace :projects do
  desc 'Read data from COVID projects spreadsheet (UNICEF)'
  task :sync_unicef_covid => :environment do |_, params|

    spreadsheet_id = "1Y6fl3Uqvn0lcFhBlYPXLKKi2HXi79kw8pWR_h8PwE3s"
    range = "1. Partners support to frontline HWs tools!A1:Z"
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first 2 - region and country
    headers.shift
    headers.shift
    puts "No data found." if response.values.empty?
    response.values.each do |row|
      region = row.shift
      country = row.shift
      row.each_with_index do |column, index| 
        if !column.nil? && !column.blank?
          #puts column + " implemented " + headers[index] + " in " + country
          create_project_entry(column, headers[index], country, "UNICEF Covid")  # org, product, country
        end
      end
    end
  end

  desc 'Read data from WHO categorization spreadsheet (Digital Square)'
  task :sync_who_categories => :environment do |_, params|

    spreadsheet_id = "1OFGTQsjtEuSU2biJtc1ps53Dbh9AaRMBr_SzVuOPxGw"
    range = "Mapping!B2:AD66"
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first column - empty
    headers.shift

    # First create all of the category data from the headers
    headers.each do |header|
      indicator = header.slice(0,3)
      desc = header[4..-1]
      if Classification.find_by(indicator: indicator).nil?
        puts "CREATING CLASSIFICATION"
        classification = Classification.new
        classification.indicator = indicator
        classification.name = desc
        classification.description = desc
        classification.source = "WHO"
        classification.save
      end
    end

    puts "No data found." if response.values.empty?
    response.values.each do |row|
      product = row.shift
      if !product.nil?
        prod_search = product.strip.downcase
        curr_product = Product.find_by("LOWER(name) LIKE ?", prod_search)
        if curr_product.nil?
          curr_product = Product.find_by("LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])", "%"+prod_search+"%", prod_search)
        end
        if !curr_product.nil?
          row.each_with_index do |column, index| 
            if !column.nil? && !column.blank?
              indicator = headers[index].slice(0,3)
              classification = Classification.find_by(indicator: indicator)
              if !classification.nil?
                puts product.to_s + " mapped to " + headers[index].to_s
                curr_class = ProductClassification.find_by("product_id=? AND classification_id=?", curr_product, classification)
                if curr_class.nil?
                  prod_class = ProductClassification.new
                  prod_class.product_id = curr_product.id
                  prod_class.classification_id = classification.id
                  prod_class.save
                end
              end
            end
          end
        else
          puts "COULD NOT FIND PRODUCT: "+product.to_s
        end
      end
    end
  end
end
