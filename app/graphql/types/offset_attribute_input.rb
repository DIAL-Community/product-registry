module Types
  class OffsetAttributeInput < Types::BaseInputObject
    description "Attributes for pagination"

    argument :offset, Integer, required: true
  end
end
