class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :load_select_options, only: [:new, :create, :edit, :update]
  skip_before_action :authorize, only: [:new, :create]
  before_action :authorize_admin_or_new, only: [:new, :create]
  before_action :authorize_admin_or_owner, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction, :is_owner?

  # GET /users
  # GET /users.json
  def index
    @users = User.order(sort_column + " " + sort_direction).
      includes([:orders])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @friends = @user.friends
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @friends = @user.friends.map { |friend| friend.id }
  end

  # POST /users
  # POST /users.json
  def create
    checked_params = check_user_params
    
    @user = User.new(checked_params)

    respond_to do |format|
      if @user.save
        unless is_logged_in?
          login @user.id
        end
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        @friends = user_params[:friends]  # Replace with simple names and IDs
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    checked_params = check_user_params
    update_successfully = false
    
    # Additionally, we must check that we aren't the last admin, trying to remove our own
    # admin priviledges. 
    if ((@user.id == session[:user_id]) && (checked_params[:role] != 'admin') && is_admin?)
      User.transaction do
        if (User.where("role = 'admin'").count > 1)
          updated_successfully = @user.update(checked_params)
        else
          @user.errors.add(:admin_error, "the last admin cannot remove their admin privileges")
        end
      end
    else
      updated_successfully = @user.update(checked_params)
    end
        
    respond_to do |format|
      if updated_successfully
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        @friends = user_params[:friends]
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # An admin can only delete themselves if there is another admin on the system
    if (@user.id == session[:user_id] && is_admin?)
      User.transaction do
        if (User.where("role = 'admin'").count > 1)
          @user.destroy
        else
          # The user cannot be destroyed, since they are the last admin
          redirect_to users_path, notice: "Failed to delete account; you are the last admin"
          return
        end
      end
    else
      # The normal case, we don't have an admin deleting themselves
      @user.destroy
    end
    
    # If you are deleting yourself
    if @user.id == session[:user_id]
      logout
      redirect_to root_path, notice: "Account deleted, logged out"
    else
      # You're deleting another user
      respond_to do |format|
        format.html { redirect_to users_url, notice: "Account deleted" }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, 
                                   :role, friends: [])
    end
    
    def check_user_params
      checked_params = user_params
      
      if checked_params[:friends]
        checked_params[:friends].delete ""
        checked_params[:friends] = checked_params[:friends].map { |id| User.find(id) }
      end
    
      # Non-admins can only create accounts with the role of 'user'
      unless is_admin?
        checked_params[:role] = 'user'
      end
      
      return checked_params
    end
    
    def load_select_options
      unless !(defined? @user) || (@user.id.nil?)
        except_id = @user.id
      else
        except_id = -1
      end
      @all_users = User.where("id != ?", except_id).order("name").map { |user| [user.name, user.id] }

      @all_roles = User.valid_roles
    end
    
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
    # Only allow admins
    def authorize_admin_or_new
      unless is_admin? || !is_logged_in?
        redirect_to users_path, notice: "Operation not permitted by non-admin"
      end
    end
    
    # Only allow the edits if they are being made by an admin or 
    # the owner of the account
    def authorize_admin_or_owner
      unless (is_admin? || is_owner?)
        redirect_to users_path, notice: "Operation not permitted by other users"
      end
    end
    
    def is_owner?(entity_user_id = params[:id])
      entity_user_id.to_i == session[:user_id].to_i
    end
end
