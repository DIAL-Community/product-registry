# frozen_string_literal: true

datasets = Product.where(product_type: 'dataset')
datasets.each do |dataset|
  puts "Moving product: #{dataset.name}."
  dpga_origin = Origin.find_by(slug: 'dpga')

  name_aliases = [dataset.name]
  dataset.aliases.each do |current_alias|
    name_aliases << current_alias unless current_alias.nil? || current_alias.blank?
  end

  existing_dataset = nil
  name_aliases.each do |name_alias|
    # Find by name, and then by aliases and then by slug.
    break unless existing_dataset.nil?

    slug = slug_em(name_alias)
    existing_dataset = Dataset.first_duplicate(name_alias, slug)
    # Check to see if both just have the same alias. In this case, it's not a duplicate
  end

  if existing_dataset.nil?
    existing_dataset = Dataset.new
    existing_dataset.name = name_aliases.first
    existing_dataset.slug = slug_em(existing_dataset.name)
  end

  website = cleanup_url(dataset.website)
  existing_dataset.website = website if !website.nil? && !website.blank?
  existing_dataset.website = 'n/a' if website.nil? || website.blank?

  # There are a lot of possible type here. Concat all of them for now.
  existing_dataset.dataset_type = 'dataset'

  # Assign what's left in the alias array as aliases.
  existing_dataset.aliases.concat(name_aliases.reject { |x| x == existing_dataset.name }).uniq!

  # Set the origin to be 'DPGA'
  if !dpga_origin.nil? && !existing_dataset.origins.exists?(id: dpga_origin.id)
    existing_dataset.origins << dpga_origin
  end

  if !dataset.sectors.nil? && !dataset.sectors.empty?
    dataset.sectors.each do |sector|
      existing_dataset.sectors << sector
    end
  end

  if !dataset.product_sustainable_development_goals.nil? && !dataset.product_sustainable_development_goals.empty?
    dataset.product_sustainable_development_goals.each do |product_sdg|
      dataset_sdg = DatasetSustainableDevelopmentGoal.new
      dataset_sdg.sustainable_development_goal_id = product_sdg.sustainable_development_goal.id
      dataset_sdg.mapping_status = product_sdg.mapping_status

      existing_dataset.dataset_sustainable_development_goals << dataset_sdg
    end
  end

  if !dataset.organizations_products.nil? && !dataset.organizations_products.empty?
    dataset.organizations_products.each do |organization_product|
      organization_dataset = OrganizationsDataset.new
      organization_dataset.organization_id = organization_product.organization.id
      organization_dataset.organization_type = organization_product.org_type

      existing_dataset.organizations_datasets << organization_dataset
    end
  end

  if existing_dataset.save!
    puts "Dataset: #{existing_dataset.name} saved."

    # Moving descriptions from product to dataset's description table.
    dataset_descriptions = ProductDescription.where(product_id: dataset.id)
    dataset_descriptions.each do |dataset_description|
      existing_dataset_description = DatasetDescription.new
      existing_dataset_description.description = dataset_description.description
      existing_dataset_description.locale = dataset_description.locale
      existing_dataset_description.dataset = existing_dataset

      if existing_dataset_description.save!
        puts "  Moving description for locale: #{existing_dataset_description.locale}."
      end
    end

    puts "Product: #{dataset.name} deleted." if dataset.destroy!
    puts "--"
  else
    puts "Saving dataset: #{existing_dataset.name} failed."
  end
end
