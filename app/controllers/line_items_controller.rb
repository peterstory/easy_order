class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  before_action :set_order
  before_action :load_select_options, only: [:new, :create, :edit, :update]
  before_action :authorize_admin_or_owner, only: [:edit, :update, :destroy]
  before_action :authorize_admin_or_participant, only: [:new, :create]
  helper_method :is_owner?

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    checked_line_item_params = check_line_item_params
    
    @line_item = LineItem.new(checked_line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @order, notice: 'Line item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    checked_line_item_params = check_line_item_params
    
    respond_to do |format|
      if @line_item.update(checked_line_item_params)
        format.html { redirect_to [@order, @line_item], notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to @order }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end
    
    def set_order
      @order = Order.find(params[:order_id])
    end
    
    def load_select_options
      @participants = @order.participants.map { |participant| [participant.user.name, participant.id] }
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      line_item_params = params.require(:line_item).permit(:order_id, :participant_id, :name, :price, :notes)
      line_item_params[:order_id] = params.require(:order_id)
      line_item_params
    end
    
    # Perform additional checking based on user account type
    def check_line_item_params
      checked_line_item_params = line_item_params
      
      # Unless you're an admin, you can only create line items for yourself
      unless is_admin?
        @order.participants.each do |participant|
          # Find the participant object that corresponds to the logged in user
          if participant.user.id == session[:user_id]
            # And make the line item be created under that user
            checked_line_item_params[:participant_id] = participant.id
            break
          end
        end
      end
      
      return checked_line_item_params
    end
    
    # Only allow the edits if they are being made by an admin or 
    # the owner of the account
    def authorize_admin_or_owner
      unless (is_admin? || is_owner?)
        redirect_to order_path(params[:order_id]), notice: "Operation not permitted by other users"
      end
    end
    
    def authorize_admin_or_participant
      unless (is_admin? || is_participant?)
        redirect_to order_path(params[:order_id]), notice: "Operation not permitted by other users"
      end
    end
    
    # Is the user the owner of the line item?
    def is_owner?(line_item_id = params[:id])
      LineItem.find(line_item_id).participant.user.id.to_i == session[:user_id].to_i
    end
    
    # Is the user a participant in the order?
    def is_participant?(order_id = params[:order_id])
      Order.find(order_id).participating_users.include?(User.find(session[:user_id]))
    end

end
