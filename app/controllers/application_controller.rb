class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize  

  protected

  def authorize
    #FIXME_AB: if !(current_user) is used to check whether user is logged in or not. So define to method for that, logged_in? and annonymous?
    redirect_to new_user_session_path if !(current_user)
  end

end
