module Types
  class ExportedPdfType < Types::BaseObject
    field :data, String, null: false
    field :filename, String, null: false
    field :locale, String, null: false
  end
end
