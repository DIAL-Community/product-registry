
module Modules
  module Slugger
    def slug_em(input)
      slug = input
        .split(%r{\s+})
        .map{|part| part.gsub(/[^A-Za-z0-9]/, "").downcase}
        .join("_")
      if (slug.length > 32)
        slug = slug.slice(0, 32)
      end
      if (slug[-1] == "_")
        slug = slug.chop
      end
      return slug
    end
  end
end