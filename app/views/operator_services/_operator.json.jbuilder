normalized_operators = {}
@operators.each do |operator|
  operator_name = operator.name

  operator_ids = normalized_operators[operator_name]
  operator_ids ||= {}
  operator_ids[operator.id] = operator.locations_id

  normalized_operators[operator_name] = operator_ids
end

json.operators normalized_operators
