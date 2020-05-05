class CreateUseCaseHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :use_case_headers do |t|
      t.references :use_case, foreign_key: true
      t.string :locale, null: false
      t.jsonb :header, null: false, default: {}
    end
  end
end
