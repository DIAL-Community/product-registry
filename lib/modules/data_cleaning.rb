# frozen_string_literal: true

module Modules
  module DataCleaning
    def GetSectors(project, product)
      subsector_list = []
      parent_sector_list = []
      unless project.nil?
        !project['Sub Sector (1)'].nil? && subsector_list << project['Sub Sector (1)']
        !project['Sub Sector (2)'].nil? && subsector_list << project['Sub Sector (2)']
        !project['Sub Sector (3)'].nil? && subsector_list << project['Sub Sector (3)']
        !project['Sub Sector (4)'].nil? && subsector_list << project['Sub Sector (4)']
        !project['Parent Sector'].nil? && parent_sector_list << project['Parent Sector']
        !project['Parent Sector (2)'].nil? && parent_sector_list << project['Parent Sector (2)']
        !project['Parent Sector (3)'].nil? && parent_sector_list << project['Parent Sector (3)']
      end

      unless product.nil?
        !product['Sub Sector (1)'].nil? && subsector_list << product['Sub Sector (1)']
        !product['Sub Sector (2)'].nil? && subsector_list << product['Sub Sector (2)']
        !product['Sub Sector (3)'].nil? && subsector_list << product['Sub Sector (3)']
        !product['Parent Sector (1)'].nil? && parent_sector_list << product['Parent Sector (1)']
        !product['Parent Sector (2)'].nil? && parent_sector_list << product['Parent Sector (2)']
      end

      all_sectors = []

      parent_sector_list.each do |parent_sector|
        foundSector = false
        subsector_list.each do |child_sector|
          curr_sector = Sector.find_by(name: "#{parent_sector}: #{child_sector}")
          unless curr_sector.nil?
            all_sectors << curr_sector
            foundSector = true
          end
        end
        unless foundSector
          curr_sector = Sector.find_by(name: parent_sector)
          !curr_sector.nil? && all_sectors << curr_sector
        end
      end
      all_sectors
    end
  end
end
