module BuildingBlocksHelper
  def footer(building_block, category)
    images = []
    case category
    when 'products'
      building_block.products.each do |product|
        next if product.nil?

        tooltip = t('view.building-block.index.bb-product') + product.name
        image = Hash[filename: "products/#{product.slug}.png", tooltip: tooltip, id: product.id, controller: 'products']
        images.push(image)
      end
    when 'workflows'
      building_block.workflows.each do |workflow|
        next if workflow.nil?

        image = Hash[name: workflow.name, id: workflow.id, controller: 'workflows']
        images.push(image)
      end
    end
    images
  end

  def footer_image_popover(elements)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t('view.building-block.index.bb-product-popover', count: elements.count) +
              '</div><div>' + format_image_popover(elements) + '</div>'
    content.html_safe
  end

  def footer_text_popover(elements)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t('view.building-block.index.bb-workflow-popover', count: elements.count) +
              '</div><div>' + format_text_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def format_image_popover(elements)
    formatted = ''
    elements.sort { |x, y| x[:name] <=> y[:name] }
            .each do |element|
      formatted += link_to(image_tag(element[:filename], class: 'popover-image', title: element[:tooltip]),
                           action: 'show', controller: element[:controller], id: element[:id])
    end
    formatted
  end

  def format_text_popover(elements)
    formatted = ''
    elements.sort { |x, y| x[:name] <=> y[:name] }
            .each do |element|
      formatted += '<div>'
      formatted += link_to(element[:name], action: 'show', controller: element[:controller], id: element[:id])
      formatted += '</div>'
    end
    formatted
  end
end
