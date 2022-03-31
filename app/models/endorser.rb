# frozen_string_literal: true

class Endorser < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_endorsers
end
