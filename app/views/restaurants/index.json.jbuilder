json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :name, :description, :street1, :street2, :city, :state, :zipcode, :phone, :fax, :url, :delivers, :delivery_charge, :menu_file
  json.url restaurant_url(restaurant, format: :json)
end
