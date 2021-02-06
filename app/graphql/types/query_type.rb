require 'combine_pdf'
require 'pdfkit'
require 'tempfile'
module Types
  class QueryType < Types::BaseObject
    include ActionView::Helpers::TextHelper

    field :playbooks, [Types::PlaybookType], null: false

    def playbooks
      Playbook.all
    end

    field :playbook, Types::PlaybookType, null: false do
      argument :slug, String, required: true
    end

    def playbook(slug:)
      playbook = Playbook.find_by(slug: slug)
      playbook.playbook_pages.each do |page|
        child_pages = PlaybookPage.where(parent_page_id: page)
                                  .order(:page_order)
        next if child_pages.empty?

        page.child_pages = []
        child_pages.each do |child_page|
          page.child_pages << child_page
          grandchild_pages = PlaybookPage.where(parent_page_id: child_page)
                                         .order(:page_order)
          next if grandchild_pages.empty?

          child_page.child_pages = []
          grandchild_pages.each do |grandchild_page|
            child_page.child_pages << grandchild_page
          end
        end
      end
      playbook
    end

    field :search_playbook, [Types::PlaybookSearchPageType], null: false do
      argument :search, String, required: true
      argument :slug, String, required: true
    end

    def search_playbook(slug:, search:)
      playbook = Playbook.find_by(slug: slug)
      child_pages = PlaybookPage.where(playbook: playbook)
                                .order(:page_order)

      matched_child_pages = []
      child_pages.each do |child_page|
        page_content = PageContent.where('LOWER(html) like LOWER(?)', "%#{search}%")
                                  .find_by(playbook_page_id: child_page)
        next if page_content.nil?

        child_page.snippet = excerpt(page_content.html, search, radius: 40)
        matched_child_pages << child_page

        grandchild_pages = PlaybookPage.where(parent_page_id: child_page)
                                       .order(:page_order)
        child_page.child_pages = []
        grandchild_pages.each do |grandchild_page|
          page_content = PageContent.where('LOWER(html) like LOWER(?)', "%#{search}%")
                                    .find_by(playbook_page_id: grandchild_page)
          next if page_content.nil?

          grandchild_page.snippet = excerpt(page_content.html, search, radius: 20)
          child_page.child_pages << grandchild_page
        end
      end
      matched_child_pages
    end

    field :export_page_content, Types::ExportedPdfType, null: false do
      argument :page_ids, [Int], required: true
      argument :locale, String, required: false, default_value: 'en'
    end

    def export_page_content(page_ids:, locale:)
      base_filename = ''
      combined_pdfs = CombinePDF.new
      page_ids.each do |page_id|
        base_filename += "#{page_id}-"

        page_content = PageContent.find_by(playbook_page_id: page_id, locale: "en")
        pdf_data = PDFKit.new(page_content.html, page_size: 'Letter')
        if page_content.editor_type != "simple"
          pdf_data.stylesheets = page_content.css
        end

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

    field :page_contents, Types::PageContentType, null: false do
      argument :playbook_page_id, ID, required: true
      argument :locale, String, required: false, default_value: 'en'
    end

    def page_contents(playbook_page_id:, locale:)
      PageContent.find_by(playbook_page_id: playbook_page_id, locale: locale[0, 2])
    end

    field :me, Types::UserType, null: false

    def me
      if !context[:current_user].nil?
        User.find(context[:current_user].id)
      else
        user = User.new
        user.id = 0
        user
      end
    end
  end
end
