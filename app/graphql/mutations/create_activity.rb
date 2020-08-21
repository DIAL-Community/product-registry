class Mutations::CreateActivity < Mutations::BaseMutation
  require 'modules/slugger'

  include Modules::Slugger

  argument :name, String, required: true
  argument :description, String, required: true
  argument :phase, String, required: true
  argument :order, Integer, required: true
  argument :playbook_id, Integer, required: true

  field :activity, Types::ActivityType, null: false
  field :errors, [String], null: false

  def resolve(name:, description:, phase:, order:, playbook_id:)
    activity = Activity.new(name: name, description: description, phase: phase, order: order, playbook_id: playbook_id)
    activity.slug = slug_em(name)
    if activity.save
      # Successful creation, return the created object with no errors
      {
        activity: activity,
        errors: [],
      }
    else
      # Failed save, return the errors to the client
      {
        activity: nil,
        errors: user.errors.full_messages
      }
    end
  end
end