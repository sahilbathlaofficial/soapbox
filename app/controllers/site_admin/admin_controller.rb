class SiteAdmin::AdminController < ActionController::Base
  layout 'site_admin'
  
  before_action :authorize_admin

  protected 

  def authorize_admin
    redirect_to root_path if !(current_user.is_admin?)
  end
end