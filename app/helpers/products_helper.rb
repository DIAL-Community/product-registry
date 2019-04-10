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
end
