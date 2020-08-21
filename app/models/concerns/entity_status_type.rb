module EntityStatusType
  extend ActiveSupport::Concern

  included do
    enum entity_status_type: { BETA: 'BETA', MATURE: 'MATURE', SELF_REPORTED: 'SELF-REPORTED', VALIDATED: 'VALIDATED' }
  end
end
