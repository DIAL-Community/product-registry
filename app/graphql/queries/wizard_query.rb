module Queries
  class WizardQuery < Queries::BaseQuery
    argument :sector, String, required: false
    argument :subsector, String, required: false
    argument :sdg, String, required: false
    argument :building_blocks, [String], required: false

    type Types::WizardType, null: false

    def resolve(sector:, subsector:, sdg:, building_blocks:)
      wizard = {}
      wizard['digital_principles'] = DigitalPrinciple.all

      sector_name = sector
      if !subsector.nil? && subsector != ''
        sector_name += ":" + subsector
      end
      curr_sector = Sector.find_by(name: sector_name)
      curr_sdg = SustainableDevelopmentGoal.find_by(name: sdg)

      sector_use_cases = []
      sdg_use_cases = []

      unless curr_sector.nil?
        sector_ids = [curr_sector.id]
        if curr_sector.parent_sector_id.nil?
          (sector_ids << Sector.where(parent_sector_id: curr_sector.id).map(&:id)).flatten!
        end
        unless curr_sector.parent_sector_id.nil?
          sector_ids << curr_sector.parent_sector_id
        end
        sector_use_cases = UseCase.where(sector_id: sector_ids, maturity: "MATURE")
      end
      unless curr_sdg.nil?
        curr_targets = SdgTarget.where(sdg_number: curr_sdg.number)
        sdg_use_cases = UseCase.where(
          "id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?)) and maturity='MATURE'",
          curr_targets.ids
        )
      end
      wizard['use_cases'] = (sector_use_cases + sdg_use_cases).uniq
      wizard['building_blocks'] = BuildingBlock.where(name: building_blocks)
      # Build list of resources manually
      wizard['resources'] = Resource.all
      wizard
    end
  end
end
