module ProductsHelper
  def digisquare_maturity_level_text(product_assessment, digisquare_maturity_yml_element)
    maturity_text = "Maturity indicator is not assigned."
    maturity_level = product_assessment.send(digisquare_maturity_yml_element["code"])
    if (maturity_level == 1)
      maturity_text = digisquare_maturity_yml_element["low"]
    end
    if (maturity_level == 2)
      maturity_text = digisquare_maturity_yml_element["medium"]
    end
    if (maturity_level == 3)
      maturity_text = digisquare_maturity_yml_element["high"]
    end
    maturity_text
  end

  def has_osc_assessment(product_assessment)
    has_assessment = false
    product_assessment.attributes.keys.select { |name| name.start_with?("osc") }.each do |key|
      has_assessment = product_assessment.send(key)
      if (has_assessment)
        break
      end
    end
    has_assessment
  end

  def has_digisquare_assessment(product_assessment)
    has_assessment = false
    product_assessment.attributes.keys.select { |name| name.start_with?("digisquare") }.each do |key|
      has_assessment = !product_assessment.send(key).nil?
      if (has_assessment)
        break
      end
    end
    has_assessment
  end
end
