# frozen_string_literal: true

class FroalaImage < ApplicationRecord
  mount_uploader :picture, FroalaImageUploader
end
