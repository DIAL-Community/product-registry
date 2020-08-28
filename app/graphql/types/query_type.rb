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
      Playbook.find_by(slug: slug)
    end

    field :me, Types::UserType, null: false 

    def me
      puts "CONTEXT: " + context[:current_user].inspect
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
