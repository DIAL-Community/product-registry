class FroalaImage < ApplicationRecord
  mount_uploader :picture, FroalaImageUploader
end
