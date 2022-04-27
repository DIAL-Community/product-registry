# frozen_string_literal: true

module ProductsHelper
  def product_endorsed(product)
    product_endorsed = false
    product.organizations.each do |org|
      product_endorsed = true if org.is_endorser
    end
    product_endorsed
  end

  def get_source_label(product)
    if product.origins.size > 1
      t('view.product.index.sources')
    else
      t('view.product.index.source')
    end
  end

  def get_row_popover(category, images)
    case category
    when 'Building Blocks'
      header = t('view.product.index.footer_popover_bb')
    when 'Compatibility'
      header = t('view.product.index.footer_popover_interop')
    when 'Sustainable Development Goals'
      header = t('view.product.index.footer_popover_sdg')
    when 'Maturity Models'
      header = t('view.product.index.footer_popover_maturity')
    when 'License'
      header = t('view.product.show.license')
    end
    content = "<div class=\"card-header bg-secondary text-white\">#{header}</div>"
    content += '<div>'
    images.each do |image|
      if image['license']
        content += '<p class="footer-source float-right">image["value"]</p>'
      elsif image['maturity']
        content += '<p class="footer-source float-right">image["value"]</p>'
      elsif image['id']
        content += link_to(image_tag(image['filename'], class: 'popover-image',
        alt: image['tooltip'], 'title': image['tooltip']),
        { action: 'show', controller: image['controller'], id: image['id'] })
      else
        content += image_tag(image['filename'], class: 'popover-image', alt: image['tooltip'],
        'title': image['tooltip'])
      end
    end
    content += '</div>'
    content.html_safe
  end

  def get_footer_row(product, rownum)
    category = get_footer_category(product, rownum)
    images = build_footer_row(product, category)
    [category, images]
  end

  def get_footer_category(product, rownum)
    category = 'none'
    category = 'Sustainable Development Goals' if rownum == 1
    if rownum == 2
      if !product.maturity_score.nil?
        category = 'Maturity Models'
      elsif !product.building_blocks.empty?
        category = 'Building Blocks'
      elsif !product.interoperates_with.empty? || !product.includes.empty?
        category = 'Compatibility'
      else
        category = 'License'
      end
    end
    category = 'sources' if rownum == 3
    category
  end

  def build_footer_row(product, category)
    images = []
    case category
    when 'Building Blocks'
      product.building_blocks.each do |bb|
        tooltip = t('view.product.index.footer_bb_candidate') + bb.name + t('view.product.index.footer_bb')
        image = Hash['filename' => bb.image_file, 'tooltip' => tooltip, 'id' => bb.id,
                     alt_text: t('alt.el-logo', el: bb.name).humanize, 'controller' => 'building_blocks']
        images.push(image)
      end
    when 'Compatibility'
      product.interoperates_with.each do |interop|
        tooltip = t('view.product.index.footer_interop') + interop.name
        image = Hash['filename' => "/assets/products/#{interop.slug}.png",
                     alt_text: t('alt.el-logo', el: interop.name).humanize,
                     'tooltip' => tooltip, 'id' => interop.id, 'controller' => 'products']
        images.push(image)
      end
      product.includes.each do |interop|
        tooltip = t('view.product.index.footer_interop') + interop.name
        image = Hash['filename' => "/assets/products/#{interop.slug}.png",
                     alt_text: t('alt.el-logo', el: interop.name).humanize,
                     'tooltip' => tooltip, 'id' => interop.id, 'controller' => 'products']
        images.push(image)
      end
    when 'Sustainable Development Goals'
      product.sustainable_development_goals.sort { |x, y| x[:number].to_i <=> y[:number].to_i }.each do |sdg|
        tooltip = "#{t('view.product.index.footer_sdg')}#{sdg.number}: #{sdg.name}"
        image = Hash['filename' => sdg.image_file, 'tooltip' => tooltip, 'id' => sdg.id,
                     alt_text: t('alt.el-logo', el: sdg.name).humanize,
                     'controller' => 'sustainable_development_goals']
        images.push(image)
      end
    when 'Maturity Models'
      tooltip = t('view.product.index.footer_osc_score')
      image = Hash['maturity' => true, 'value' => product.maturity_score]
      images.push(image)
    when 'sources'
      if product.origins.empty?
        tooltip = t('view.product.index.source_dial')
        image = Hash['filename' => 'origins/dial_osc.png',
                     alt_text: t('alt.el-logo', el: tooltip).humanize, 'tooltip' => tooltip]
        images.push(image)
      else
        product.origins.each do |origin|
          tooltip = ''
          case origin.slug
          when 'dial_osc'
            tooltip = t('view.product.index.source_dial')
          when 'digital_square'
            tooltip = t('view.product.index.source_digital_square')
          when 'unicef'
            tooltip = t('view.product.index.source_unicef')
          when 'dpga'
            tooltip = t('view.product.index.source_dpga')
          end
          image = Hash['filename' => "origins/#{origin.slug}.png",
                       alt_text: t('alt.el-logo', el: tooltip).humanize, 'tooltip' => tooltip]
          images.push(image)
        end
      end
    end
    images
  end

  def coronavirus_handler(product)
    handler = false
    @covid19_tag = Setting.find_by(slug: 'default_covid19_tag') if @covid19_tag.nil?
    !@covid19_tag.nil? && handler = product.tags.map(&:downcase).include?(@covid19_tag.value.downcase)
    handler
  end
end
