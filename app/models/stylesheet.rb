# frozen_string_literal: true

class Stylesheet < ActiveRecord::Base
  validates_presence_of :background_color
end
