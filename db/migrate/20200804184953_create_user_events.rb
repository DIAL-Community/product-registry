class CreateUserEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_events do |t|
      t.string(:identifier, null: false, unique: true)
      t.string(:email)
      t.datetime(:event_datetime, null: false)
      t.string(:event_type, null: false)
      t.jsonb(:extended_data, null: false, default: {})

      t.timestamps
    end
  end
end
