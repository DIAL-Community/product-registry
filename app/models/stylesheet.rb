class Stylesheet < ActiveRecord::Base
  validates_presence_of :background_color
end