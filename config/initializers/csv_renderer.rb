# frozen_string_literal: true

ActionController::Renderers.add(:csv) do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.to_s
  str = obj.to_csv if obj.respond_to?(:to_csv)
  send_data str, disposition: "attachment; filename=#{filename}.csv"
end
