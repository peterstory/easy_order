class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /users
  # GET /users.json
  def index
    @users = User.order(sort_column + " " + sort_direction)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @friends = @user.friends
  end

  # GET /users/new
  def new
    @user = User.new
    @all_users = all_user_names_ids
  end

  # GET /users/1/edit
  def edit
    @all_users = all_user_names_ids params[:id]
    @friends = Array.new
    User.find(params[:id]).friends.each do |friend|
      @friends.push friend.id
    end
  end

  # POST /users
  # POST /users.json
  def create
    checked_params = user_params
    if checked_params[:friends]
      checked_params[:friends].delete ""
      checked_params[:friends] = checked_params[:friends].map { |id| User.find(id) }
    end
    
    @user = User.new(checked_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        @all_users = all_user_names_ids
        @friends = user_params[:friends]  # Replace with simple names and IDs
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    checked_params = user_params
    if checked_params[:friends]
      checked_params[:friends].delete ""
      checked_params[:friends] = checked_params[:friends].map { |id| User.find(id) }
    end
    
    respond_to do |format|
      if @user.update(checked_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        @all_users = all_user_names_ids
        @friends = user_params[:friends]
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
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
    
    # Accepts an optional parameter of the current user, who is not to be included
    def all_user_names_ids(except_id = -1)
      all_users = Array.new
      User.where("id != ?", except_id).order("name").each do |user|
        all_users.push([user.name, user.id])
      end
      return all_users
    end
    
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
