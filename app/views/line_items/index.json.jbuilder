json.array!(@line_items) do |line_item|
  json.extract! line_item, :participant_id, :order_id, :name, :price, :notes
  json.url line_item_url(line_item, format: :json)
end
