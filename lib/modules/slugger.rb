# frozen_string_literal: true

module Modules
  module Slugger
    def slug_em(input, max_length = 32)
      slug = input
             .split(/\s+/)
             .map { |part| part.gsub(/[^A-Za-z0-9]/, '').downcase }
             .join('_')
      slug = slug.slice(0, max_length) if slug.length > max_length
      slug = slug.chop if slug[-1] == '_'
      slug
    end
  end
end
