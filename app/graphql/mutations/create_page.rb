class Mutations::CreatePage < Mutations::BaseMutation
  require 'modules/slugger'

  include Modules::Slugger

  argument :name, String, required: true
  argument :description, String, required: true
  argument :phase, String, required: true
  argument :order, Integer, required: true
  argument :playbook_id, Integer, required: true

  field :page, Types::PlaybookPageType, null: false
  field :errors, [String], null: false

  def resolve(name:, description:, phase:, order:, playbook_id:)
    playbook_page = PlaybookPage.new(name: name, description: description, phase: phase, order: order, playbook_id: playbook_id)
    playbook_page.slug = slug_em(name)
    if playbook_page.save
      # Successful creation, return the created object with no errors
      {
        playbook_page: playbook_page,
        errors: []
      }
    else
      # Failed save, return the errors to the client
      {
        playbook_page: nil,
        errors: user.errors.full_messages
      }
    end
  end
end
