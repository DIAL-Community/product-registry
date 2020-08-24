module MappingStatusType
  extend ActiveSupport::Concern

  included do
    enum mapping_status_type: { BETA: 'BETA', MATURE: 'MATURE', SELF_REPORTED: 'SELF-REPORTED', VALIDATED: 'VALIDATED' }
  end
end
