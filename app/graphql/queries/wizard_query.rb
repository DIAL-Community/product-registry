module Queries

  class WizardQuery < Queries::BaseQuery
    argument :phase, String, required: true
    argument :sector, String, required: true
    argument :buildingBlocks, [String], required: true

    type Types::WizardType, null: false

    def resolve(phase:, sector:, buildingBlocks:)
      wizard = {}
      principles = {}

      principles['Ideation'] = ['understand_existing_ecosystem', 'design_with_the_user', 'reuse_and_improve']
      principles['Planning'] = ['design_with_the_user', 'design_for_scale', 'be_collaborative']
      principles['Implementation'] = ['be_data_driven', 'use_open_standards', 'address_privacy_security']
      principles['Monitoring'] = ['be_data_driven', 'be_collaborative', 'understand_existing_ecosystem']

      wizard['digital_principles'] = DigitalPrinciple.where(slug: principles[phase])

      currSector = Sector.find_by(name: sector)
      
      if phase == 'Ideation'
        sectorProjects = ProjectsSector.where(sector_id: currSector.id).limit(10).map(&:project_id)
        wizard['projects'] = Project.where(id: sectorProjects)
        useCases = UseCase.where(sector_id: currSector.id)
        wizard['use_cases'] = UseCase.where(sector_id: currSector.id)
      end

      if phase == 'Planning'
        wizard['building_blocks'] = BuildingBlock.where(name: buildingBlocks)
        # Build list of resources manually
        wizard['resources'] = [{name: 'D4D Handbook', image_url: 'https://solutions.dial.community//assets/playbooks/pictures/608/PLAYBOOK_FOR_CATALOG.png', link: 'https://resources.dial.community/resources/md4d_handbook'}, 
            {name: 'Procurement Guide', image_url: '', link: 'https://procurement-digitalimpactalliance.org'}]
      end

      if phase == 'Implementation'
        bbs = BuildingBlock.where(name: buildingBlocks)
        productBB = ProductBuildingBlock.where(building_block_id: bbs).map(&:product_id)
        wizard['products'] = Product.where(id: productBB)
        wizard['organizations'] = Organization.where(is_mni: true)
      end

      if phase == 'Evaluation'
        # Build list of resources manually
        wizard['resources'] = [{name: 'ROI Toolkit', image_url: '', link: 'https://resources.dial.community/resources/valuing_impact_toolkit'}]
      end

      wizard
    end
  end
end