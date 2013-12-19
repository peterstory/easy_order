class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :menu, :edit, :update, :destroy]
  before_action :load_select_options, only: [:index, :new, :create, :edit, :update]
  helper_method :sort_column, :sort_direction, :map_url, :directions_url

  # GET /restaurants
  # GET /restaurants.json
  def index
    sorting_direction = sort_direction
    
    # Ascending order should have restaurants that deliver first
    if sort_column == "delivers"
      sorting_direction = sorting_direction == "asc" ? "desc" : "asc"
    end
    
    @restaurants = Restaurant.order(sort_column + " " + sorting_direction)
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end
  
  # GET /restaurants/menu/1
  def menu
    @menu = @restaurant.menu
    send_data(@menu.data, filename: @menu.name, 
                          type: @menu.content_type, 
                          dispostion: "inline")
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    checked_params = restaurant_params
    if checked_params["uploaded_menu"]
      checked_params[:menu] = Menu.new ({ "uploaded_menu" => checked_params.delete("uploaded_menu")})
    end
    @restaurant = Restaurant.new(checked_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render action: 'show', status: :created, location: @restaurant }
      else
        format.html { render action: 'new' }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    checked_params = restaurant_params
    if checked_params["uploaded_menu"]
      checked_params[:menu] = Menu.new ({ "uploaded_menu" => checked_params.delete("uploaded_menu")})
    end
    
    respond_to do |format|
      if @restaurant.update(checked_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :description, :cuisine, :street1, :street2, :city, :state, :zipcode, :phone, :fax, :url, :delivers, :delivery_charge, :uploaded_menu)
    end
    
    def load_select_options
      @all_cuisines = Restaurant.valid_cuisines
      @all_cities = Restaurant.select(:city).map{ |city| city[:city] }
      @all_cities.uniq!
      @all_states = Restaurant.select(:state).map{ |state| state[:state] }
      @all_states.uniq!
    end
    
    def map_url
      url = "http://maps.googleapis.com/maps/api/staticmap?size=512x400&sensor=false"
      
      # Add map center
      location = @restaurant.street1
      location += " " + @restaurant.street2 if @restaurant.street2
      location += " " + @restaurant.city + " " + @restaurant.state
      url += "&center=" + CGI::escape(location)
      
      # Add marker
      url += "&markers=" + CGI::escape(location)
      
      return url
    end
    
    def directions_url
      
      if is_ios_device?
        url = "http://maps.apple.com/"
      else
        url = "http://maps.google.com/"
      end
      
      destination = @restaurant.street1
      destination += " " + @restaurant.street2 if @restaurant.street2
      destination += " " + @restaurant.city + " " + @restaurant.state
      url += "?daddr=" + CGI::escape(destination)
    end
    
    def sort_column
      Restaurant.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
