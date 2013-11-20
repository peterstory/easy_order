function restaurantSearch(event) {
	var i = 0; // counter
	
	var searchOptions = ["cuisine", "city", "state"];
	var selectedOptions = [];
	for (i = 0; i < searchOptions.length; i++) 
	{
		selectedOptions[i] = $("#search_" + searchOptions[i]).find(":selected").val();
	}
	
	var restaurants = $('li.restaurant');
	var hiddenCount = 0;
	restaurants.each(function(index, restaurant) {
		var restaurantData = $.parseJSON($(restaurant).attr("data"));
		var showRestaurant = true;
		for (i = 0; i < searchOptions.length; i++)
		{
			// If we have an actual option selected
			if (selectedOptions[i] != ("- " + searchOptions[i] + " -"))
			{
				if (restaurantData[searchOptions[i]] != selectedOptions[i])
				{
					showRestaurant = false;
					break;
				}
			}
		}
		
		if (showRestaurant) {
			$(restaurant).show();
		}
		else {
			$(restaurant).hide();
			hiddenCount++;
		}
	});
	
	// If we hid everything, we should display a message to the user
	if (hiddenCount == restaurants.length) {
		if ($("ul.restaurant_list li.none_found").length == 0) {
			$("ul.restaurant_list").append("<li class='none_found'>No restaurants matching search criteria</li>");
		}
	}
	else {
		$("ul.restaurant_list li.none_found").remove();
	}
}