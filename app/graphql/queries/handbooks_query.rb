# frozen_string_literal: true

require 'combine_pdf'
require 'pdfkit'
require 'tempfile'

module Queries
  class HandbooksQuery < Queries::BaseQuery
    graphql_name 'Handbooks'

    type [Types::HandbookType], null: false

    def resolve
      Handbook.all
    end
  end

  class HandbookQuery < Queries::BaseQuery
    argument :slug, String, required: true

    type Types::HandbookType, null: false

    def resolve(slug:)
      handbook = Handbook.find_by(slug: slug)
      handbook.handbook_pages.each do |page|
        child_pages = HandbookPage.where(parent_page_id: page)
                                  .order(:page_order)
        next if child_pages.empty?

        page.child_pages = []
        child_pages.each do |child_page|
          page.child_pages << child_page
          grandchild_pages = HandbookPage.where(parent_page_id: child_page)
                                         .order(:page_order)
          next if grandchild_pages.empty?

          child_page.child_pages = []
          grandchild_pages.each do |grandchild_page|
            child_page.child_pages << grandchild_page
          end
        end
      end
      handbook
    end
  end

  class SearchHandbookQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    argument :slug, String, required: true

    type [Types::HandbookSearchPageType], null: false

    def resolve(slug:, search:)
      handbook = Handbook.find_by(slug: slug)
      child_pages = HandbookPage.where(handbook: handbook)
                                .order(:page_order)

      matched_child_pages = []
      child_pages.each do |child_page|
        page_content = PageContent.where('LOWER(html) like LOWER(?)', "%#{search}%")
                                  .find_by(handbook_page_id: child_page)
        next if page_content.nil?

        child_page.snippet = excerpt(page_content.html, search, radius: 40)
        matched_child_pages << child_page

        grandchild_pages = HandbookPage.where(parent_page_id: child_page)
                                       .order(:page_order)
        child_page.child_pages = []
        grandchild_pages.each do |grandchild_page|
          page_content = PageContent.where('LOWER(html) like LOWER(?)', "%#{search}%")
                                    .find_by(handbook_page_id: grandchild_page)
          next if page_content.nil?

          grandchild_page.snippet = excerpt(page_content.html, search, radius: 20)
          child_page.child_pages << grandchild_page
        end
      end
      matched_child_pages
    end
  end

  class ExportPageContentsQuery < Queries::BaseQuery
    argument :page_ids, [Int], required: true
    argument :locale, String, required: false, default_value: 'en'

    type Types::ExportedPdfType, null: false

    def resolve(page_ids:, locale:)
      base_filename = ''
      combined_pdfs = CombinePDF.new
      page_ids.each do |page_id|
        base_filename += "#{page_id}-"

        page_content = PageContent.find_by(handbook_page_id: page_id, locale: 'en')
        next if page_content.nil? || page_content.html.nil?

        pdf_data = PDFKit.new(page_content.html, page_size: 'Letter')
        pdf_data.stylesheets = page_content.css if page_content.editor_type != 'simple'

        temporary = Tempfile.new(Time.now.strftime('%s'))
        pdf_data.to_file(temporary.path)

        combined_pdfs << CombinePDF.load(temporary.path)
      end

      temporary = Tempfile.new(Time.now.strftime('%s'))
      combined_pdfs.save(temporary.path)

      returned_data = {}

      returned_data[:filename] = "Page-#{base_filename}-exported.pdf"
      returned_data[:data] = Base64.strict_encode64(File.read(temporary.path))
      returned_data[:locale] = locale
      returned_data
    end
  end

  class PageContentsQuery < Queries::BaseQuery
    argument :handbook_page_id, ID, required: true
    argument :locale, String, required: false, default_value: 'en'

    type Types::PageContentType, null: false

    def resolve(handbook_page_id:, locale:)
      PageContent.find_by(handbook_page_id: handbook_page_id, locale: locale[0, 2])
    end
  end
end
