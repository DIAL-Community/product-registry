ActionController::Renderers.add(:csv) do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.to_s
  if obj.respond_to?(:to_csv)
    str = obj.to_csv
  end
  send_data str, disposition: "attachment; filename=#{filename}.csv"
end
