class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.order(sort_column + " " + sort_direction).
      includes([:restaurant, :organizer, :participants => :user])
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    load_select_options
  end

  # GET /orders/1/edit
  def edit
    load_select_options
    @participating_users = @order.participating_users.map { |user| user.id }
  end

  # POST /orders
  # POST /orders.json
  def create
    checked_params = order_params
    if checked_params[:participating_users]
      checked_params[:participating_users].delete ""
      checked_params[:participating_users] = checked_params[:participating_users].map { |id| User.find(id) }
    end
    
    @order = Order.new(checked_params)
    
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        refactor_errors
        load_select_options
        @participating_users = order_params[:participating_users]
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    checked_params = order_params
    if checked_params[:participating_users]
      checked_params[:participating_users].delete ""
      checked_params[:participating_users] = checked_params[:participating_users].map { |id| User.find(id) }
    end
    
    respond_to do |format|
      if @order.update(checked_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        refactor_errors
        load_select_options
        @participating_users = order_params[:participating_users]
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # Note that :total was removed, since we don't want that field to be directly editable
    def order_params
      params.require(:order).permit(:restaurant_id, :organizer_id, :type, :status, :placed_at, 
        participating_users: [])
    end
    
    def load_select_options
      @all_restaurants = Restaurant.all.map { |restaurant| [restaurant.name, restaurant.id] }
      @all_users = User.all.map { |user| [user.name, user.id] }      
      @all_types = Order.valid_types
      @all_statuses = Order.valid_statuses
    end
    
    # Change where errors are stored, so highlighting works properly
    def refactor_errors
      @order.errors[:restaurant].map { |error| @order.errors[:restaurant_id] = error }
      @order.errors.delete :restaurant
      @order.errors[:organizer].map { |error| @order.errors[:organizer_id] = error }
      @order.errors.delete :organizer
    end
    
    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
