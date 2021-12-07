class MoveRepositoryDataFromProductTable < ActiveRecord::Migration[5.2]
  def up
    Product.all.each do |current_product|
      product = current_product
      unless current_product.parent_product_id.nil?
        product = Product.find(current_product.parent_product_id)
      end

      repository_attrs = {
        name: "#{current_product.name} Repository",
        absolute_url: current_product.repository.blank? ? 'N/A' : current_product.repository,
        description: "Repository of #{current_product.name}.",
        main_repository: current_product.is_child.to_s != 'true',

        dpga_data: current_product.publicgoods_data.nil? ? '{}' : current_product.publicgoods_data,
        language_data: current_product.language_data.nil? ? '{}' : current_product.language_data,
        statistical_data: current_product.statistics.nil? ? '{}' : current_product.statistics,

        license_data: current_product.license_analysis.nil? ? '{}' : current_product.license_analysis,
        license: current_product.license.blank? ? 'N/A' : current_product.license,

        code_lines: current_product.code_lines,
        cocomo: current_product.cocomo,
        est_hosting: current_product.est_hosting,
        est_invested: current_product.est_invested
      }

      current_repository = ProductRepository.find_by(product_id: product.id, name: repository_attrs[:name])
      if current_repository.nil?
        repository_attrs[:product] = product
        repository_attrs[:slug] = slug_em(repository_attrs[:name])
        current_repository = ProductRepository.create!(repository_attrs)
        puts "  Created repository for: #{current_repository.name}."
      else
        puts "  Repository exists: #{current_repository.name}."
      end
    end
  end

  def down
    ProductRepository.all.each do |product_repository|
      product_attrs = {
        repository: product_repository.absolute_url,
        is_child: product_repository.main_repository.to_s == 'true',
        parent_product_id: product_repository.main_repository.to_s != 'true' ? product_repository.product.id : nil,

        publicgoods_data: product_repository.dpga_data,
        language_data: product_repository.language_data,
        statistics: product_repository.statistical_data,

        license: product_repository.license,
        license_analysis: product_repository.license_data,

        code_lines: product_repository.code_lines,
        cocomo: product_repository.cocomo,
        est_hosting: product_repository.est_hosting,
        est_invested: product_repository.est_invested
      }

      product = Product.find_by(name: product_repository.name.gsub(' Repository', ''))
      # We couldn't find product matching the repo name, skip
      if product.nil?
        puts "Unable to find repository for: #{product_repository.name}."
      elsif product.update!(product_attrs)
        puts "Updated repository information for: #{product.name}."
      else
        puts "Unable to update repository information for: #{product_repository.name}."
      end
    end
  end
end
