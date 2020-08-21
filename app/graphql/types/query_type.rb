module Types
  class QueryType < Types::BaseObject
    field :playbooks, [Types::PlaybookType], null: false

    def playbooks
      Playbook.all
    end

    field :playbook, Types::PlaybookType, null: false do
      argument :id, ID, required: true
    end

    def playbook(id:)
      puts Playbook.find(id).inspect
      Playbook.find(id)
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
