class AggregatorCapability < ActiveRecord::Base
  has_one :operator_service, foreign_key: 'id'
  belongs_to :organization, foreign_key: 'aggregator_id'
  belongs_to :country

  def self.to_csv
    attributes = %w{aggregator_id operator_services_id service capability country_name}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |agg|
        csv << [agg.organization.name, agg.operator_services_id, agg.service, agg.capability, agg.country_name ]
      end
    end
  end

  def operator_service_id
    operator_services_id
  end
end
