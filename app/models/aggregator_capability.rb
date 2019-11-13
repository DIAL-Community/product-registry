class AggregatorCapability < ActiveRecord::Base
  has_one :operator_service, foreign_key: 'id'
  belongs_to :organization, foreign_key: 'aggregator_id'

  def self.to_csv
    attributes = %w{aggregator_id operator_services_id service capability country_name}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |agg|
        csv << [agg.organization.name, agg.operator_services_id, agg.service, agg.capability, agg.country_name ]
      end
    end
  end
end
