class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin_or_owner, only: [:edit, :update, :destroy]
  before_action :authorize_admin_or_participant, only: [:show]
  helper_method :sort_column, :sort_direction, :only_for_user, :is_owner?, :is_item_owner?, :is_participant?

  # GET /orders
  # GET /orders.json
  def index
    if is_admin?
      # Admins can narrow their search, but will otherwise see all orders
      user_id = only_for_user
      unless user_id
        @orders = Order.order(sort_column + " " + sort_direction).
          includes([:restaurant, :organizer, :participants => :user])
      else
        @orders = User.find(user_id).orders.order(sort_column + " " + sort_direction).
          includes(:restaurant, :organizer, :participants => :user)
      end
    else
      # Regular users can only see the orders in which they participate
      @orders = User.find(session[:user_id]).orders.order(sort_column + " " + sort_direction).
        includes(:restaurant, :organizer, :participants => :user)
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    # Load line items
    @participant_line_items = Hash.new
    @order.participants.each do |participant|
      line_items = LineItem.where("order_id = ? and participant_id = ?", @order.id, participant.id)
      @participant_line_items[participant] = line_items
    end
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
    checked_params = check_order_params
        
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
    checked_params = check_order_params
    
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
    
    # Perform additional massaging of parameters
    def check_order_params
      checked_params = order_params
    
      # Unless you're an admin, replace the organizer_id with your own user_id
      unless is_admin?
        checked_params[:organizer_id] = session[:user_id]
      end
      
      # Don't allow checked_params to be nil, or our following code will explode
      checked_params[:participating_users] = [] if checked_params[:participating_users].nil?
      # Make sure the organizer is also a participant
      unless checked_params[:participating_users].include?(checked_params[:organizer_id])
        checked_params[:participating_users].push(checked_params[:organizer_id])
      end
    
      # Replace user IDs with User objects
      if checked_params[:participating_users]
        checked_params[:participating_users].delete ""
        checked_params[:participating_users] = checked_params[:participating_users].map { |id| User.find(id) }
      end
      
      return checked_params
    end
    
    def load_select_options
      @all_restaurants = Restaurant.all.map { |restaurant| [restaurant.name, restaurant.id] }
      @all_users = User.all.map { |user| [user.name, user.id] }
      @user_name = User.find(session[:user_id]).name
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
    
    def only_for_user
      params[:user_id]
    end
    
    # Only allow the edits if they are being made by an admin or 
    # the owner of the account
    def authorize_admin_or_owner
      unless (is_admin? || is_owner?)
        redirect_to orders_path, notice: "Operation not permitted by other users"
      end
    end
    
    def authorize_admin_or_participant
      unless (is_admin? || is_participant?)
        redirect_to orders_path, notice: "Operation not permitted by other users"
      end
    end
    
    def is_owner?(order_id = params[:id])
      Order.find(order_id).organizer.id.to_i == session[:user_id].to_i
    end
    
    # Is the user the owner of the line item?
    # Copy of is_owner? from line_items_controller.rb
    def is_item_owner?(line_item_id = params[:id])
      LineItem.find(line_item_id).participant.user.id.to_i == session[:user_id].to_i
    end
    
    def is_participant?(order_id = params[:id])
      Order.find(order_id).participating_users.include?(User.find(session[:user_id]))
    end
end
