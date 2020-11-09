module Types
  class QueryType < Types::BaseObject
    field :playbooks, [Types::PlaybookType], null: false

    def playbooks
      Playbook.all
    end

    field :playbook, Types::PlaybookType, null: false do
      argument :slug, String, required: true
    end

    def playbook(slug:)
      playbook = Playbook.includes(:playbook_pages).where(playbook_pages: { parent_page_id: nil }).find_by(slug: slug)
      playbook.playbook_pages.each do |page|
        child_pages = PlaybookPage.where(parent_page_id: page).order(:page_order)
        if !child_pages.empty?
          page.child_pages = []
          child_pages.each do |child_page|
            page.child_pages << child_page
            grandchild_pages = PlaybookPage.where(parent_page_id: child_page).order(:page_order)
            if !grandchild_pages.empty?
              child_page.child_pages = []
              grandchild_pages.each do |grandchild_page|
                child_page.child_pages << grandchild_page
              end
            end
          end
        end
      end
      playbook
    end

    field :playbook_page, Types::PlaybookPageType, null: false do
      argument :playbookPageSlug, String, required: true
    end

    def playbook_page(playbookPageSlug:)
      PlaybookPage.find_by(slug: playbookPageSlug)
    end

    field :me, Types::UserType, null: false 

    def me
      if !context[:current_user].nil?
        User.find(context[:current_user].id)
      else
        user = User.new
        user.id = 0
        user
        #{ "id" => 13, "email" => "sconrad@digitalimpactalliance.org"} 
      end
    end

  end
end
