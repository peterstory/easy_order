class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authorize
  helper_method :is_logged_in?, :is_admin?
  
  protected
    # Only allow logged-in users
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
    
    # Check whether the user is logged in
    def is_logged_in?
      User.exists?(session[:user_id])
    end
  
    # Check whether the user is logged in and administrator
    def is_admin?
      if session[:user_id]
        user = User.find_by_id(session[:user_id])
        return (( !!user ) && ( user.role == 'admin' ))
      else
        return false
      end
    end
    
    def login(user_id)
      session[:user_id] = user_id
    end
    
    def logout
      session[:user_id] = nil
    end
end
