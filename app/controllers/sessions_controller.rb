class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    
    if user and user.authenticate(params[:password])
      login user.id
      redirect_to root_path
    else
      flash.now[:notice] = "Invalid user/password combination" 
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out"
  end
end
