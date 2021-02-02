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
      Playbook.find_by(slug: slug)
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
