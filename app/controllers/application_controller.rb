class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :slug_em

    def slug_em(input)
      slug = input
        .split(%r{\s+})
        .map{|part| part.gsub(/[^A-Za-z]/, "").downcase}
        .join("_")

      if (slug.length > 32)
        slug = slug.slice(0, 32)
      end

      if (slug[-1] == "_")
        slug = slug.chop
      end

      return slug
    end

    def calculate_offset(first_duplicate)
      size = 1;
      if (!first_duplicate.nil?)
        size = first_duplicate.slug.delete('^0-9').to_i + 1
      end
      return size
    end
end
