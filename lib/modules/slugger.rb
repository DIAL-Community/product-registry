
module Modules
  module Slugger
    def slug_em(input, max_length=32)
      slug = input
        .split(%r{\s+})
        .map{|part| part.gsub(/[^A-Za-z0-9]/, "").downcase}
        .join("_")
      if (slug.length > max_length)
        slug = slug.slice(0, max_length)
      end
      if (slug[-1] == "_")
        slug = slug.chop
      end
      return slug
    end
  end
end