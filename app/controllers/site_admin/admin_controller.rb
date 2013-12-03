class SiteAdmin::AdminController < ApplicationController
  
  layout 'site_admin'
  before_action :authorize_admin

  protected 

  def authorize_admin
    # CR_Priyank: Try to be simple with what you use. Like we can also use unless here
    # [Fixed] - Added 
    redirect_to root_path  unless (current_user.is_admin?)
  end

end