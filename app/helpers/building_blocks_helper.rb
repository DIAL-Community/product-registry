module BuildingBlocksHelper
  def bb_footer(building_block, category)
    images = []
    case category
    when 'products'
      building_block.products.each do |product|
        next if product.nil?

        tooltip = t('view.building-block.index.bb-product') + product.name
        image = Hash[filename: product.image_file, tooltip: tooltip, id: product.id, controller: 'products']
        images.push(image)
      end
    when 'workflows'
      building_block.workflows.each do |workflow|
        next if workflow.nil?

        tooltip = t('view.building-block.index.bb-workflow') + workflow.name
        image = Hash[filename: workflow.image_file, tooltip: tooltip, id: workflow.id, controller: 'workflows']
        images.push(image)
      end
    end
    images
  end

  def bb_footer_popover(elements, title)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t(title, count: elements.count) +
              '</div><div>' + bb_format_image_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def bb_format_image_popover(elements)
    formatted = ''
    elements.sort_by { |x| x[:name] }
            .each do |element|
      formatted += link_to(image_tag(element[:filename], class: 'popover-image', title: element[:tooltip]),
                           action: 'show', controller: element[:controller], id: element[:id])
    end
    formatted
  end
end
