json.array!(@orders) do |order|
  json.extract! order, :restaurant_id, :organizer_id, :type, :total, :status, :placed_at
  json.url order_url(order, format: :json)
end
