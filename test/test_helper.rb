ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  # Duplicates of the versions in application_controller.rb
  def login(user_id)
    session[:user_id] = user_id
  end
  def logout
    session[:user_id] = nil
  end
  def is_admin?
    if session[:user_id]
      user = User.find_by_id(session[:user_id])
      return (( !!user ) && ( user.role == 'admin' ))
    else
      return false
    end
  end

  # Add more helper methods to be used by all tests here...
end
