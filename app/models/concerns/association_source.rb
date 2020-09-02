module AssociationSource
  extend ActiveSupport::Concern

  included do
    enum association_source: { LEFT: 'LEFT', RIGHT: 'RIGHT' }
  end
end
