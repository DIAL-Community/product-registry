module ProductsHelper

  def is_endorsed(product)
    is_endorsed = false
    product.organizations.each do |org|
      if (org.is_endorser)
        is_endorsed = true
      end
    end
    is_endorsed
  end

  def get_source_label(product)
    if (product.origins.size > 1)
      label = t("view.product.index.sources")
    else
      label = t("view.product.index.source")
    end
  end

  def get_row_popover(category,images)
    case category
    when "Building Blocks"
      header = t("view.product.index.footer_popover_bb")
    when "Compatibility"
      header = t("view.product.index.footer_popover_interop")
    when "Sustainable Development Goals"
      header = t("view.product.index.footer_popover_sdg")
    when "Maturity Models"
      header = t("view.product.index.footer_popover_maturity")
    when "License"
      header = t("view.product.show.license")
    end
    content = '<div class="card-header bg-secondary text-white">'+header+'</div>'
    content += '<div>'
    images.each do |image|
      if image["license"]
        content += '<p class="footer-source float-right">image["value"]</p>'
      elsif image["maturity"]
        content += '<p class="footer-source float-right">image["value"]</p>'
      else
        if image["id"]
          content += link_to image_tag(image["filename"], class: 'popover-image', 'title' => image["tooltip"]), {action:'show', controller: image["controller"], id: image["id"]}
        else
          content += image_tag(image["filename"], class: 'popover-image', 'title' => image["tooltip"])
        end
      end
    end
    content += "</div>"
    content.html_safe
  end

  def get_footer_row(product, rownum)
    category = get_footer_category(product, rownum)
    images = build_footer_row(product, category)
    return category, images
  end

  def get_footer_category(product, rownum)
    category = "none"
    if (rownum == 1)
      category = "Sustainable Development Goals"
    end
    if (rownum == 2)
      if !product.maturity_score.nil?
        category = "Maturity Models"
      elsif product.building_blocks.size > 0
        category = "Building Blocks"
      elsif (product.interoperates_with.size > 0) || (product.includes.size > 0)
        category = "Compatibility"
      else
        category = "License"
      end
    end
    if (rownum == 3)
      category = "sources"
    end
    category
  end

  def build_footer_row(product, category)
    images = []
    case category
    when "Building Blocks"
      product.building_blocks.each do |bb|
        tooltip = t("view.product.index.footer_bb_candidate") + bb.name + t("view.product.index.footer_bb")
        image = Hash["filename"=>bb.image_file, "tooltip"=>tooltip, "id"=>bb.id, "controller"=>"building_blocks"]
        images.push(image)
      end
    when "License"
      tooltip = product.license
      image = Hash["license"=>true, "value"=>product.license]
      images.push(image)
    when "Compatibility"
      product.interoperates_with.each do |interop|
        tooltip = t("view.product.index.footer_interop") + interop.name
        image = Hash["filename"=>"/assets/products/"+interop.slug+".png", "tooltip"=>tooltip, "id"=>interop.id, "controller"=>"products"]
        images.push(image)
      end
      product.includes.each do |interop|
        tooltip = t("view.product.index.footer_interop") + interop.name
        image = Hash["filename"=>"/assets/products/"+interop.slug+".png", "tooltip"=>tooltip, "id"=>interop.id, "controller"=>"products"]
        images.push(image)
      end
    when "Sustainable Development Goals"
      product.sustainable_development_goals.sort { |x, y| x[:number].to_i <=> y[:number].to_i }.each do |sdg|
        tooltip = t("view.product.index.footer_sdg") + sdg.number.to_s + ": " + sdg.name
        image = Hash["filename"=>sdg.image_file, "tooltip"=>tooltip, "id"=>sdg.id, "controller"=>"sustainable_development_goals"]
        images.push(image)
      end
    when "Maturity Models"
      tooltip = t("view.product.index.footer_osc_score")
      image = Hash["maturity"=>true, "value"=>product.maturity_score]
      images.push(image)
    when "sources"
      if (product.origins.size == 0)
        tooltip = t("view.product.index.source_dial")
        image = Hash["filename"=>"origins/dial_osc.png", "tooltip"=>tooltip]
        images.push(image)
      else
        product.origins.each do |origin|
          tooltip = ""
          case origin.slug
          when "dial_osc"
            tooltip = t("view.product.index.source_dial")
          when "digital_square"
            tooltip = t("view.product.index.source_digital_square")
          when "unicef"
            tooltip = t("view.product.index.source_unicef")
          end
          image = Hash["filename"=>"origins/"+origin.slug+".png", "tooltip"=>tooltip]
          images.push(image)
        end
      end
    end
    images
  end

  def coronavirus_handler(product)
    handler = false
    if @covid19_tag.nil?
      @covid19_tag = Setting.find_by(slug: 'default_covid19_tag')
    end
    !@covid19_tag.nil? && handler = product.tags.map(&:downcase).include?(@covid19_tag.value.downcase)
    handler
  end

end
