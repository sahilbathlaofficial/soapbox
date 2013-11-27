# CR_Priyank: remove unwanted/commented code
#[Fixed] - Removed unwanted code

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize  
  before_action :set_locale
  helper_method :current_company
 
  protected

  def set_locale
    if(['hi','en'].include?(params[:locale]))
      I18n.locale = params[:locale] 
    else
      I18n.locale = I18n.default_locale
    end
  end

  def authorize
    #FIXME_AB: if !(current_user) is used to check whether user is logged in or not. So define to method for that, logged_in? and annonymous?
    #[Fixed]
    redirect_to new_user_session_path if anonymous?
  end

  def anonymous?
    current_user.nil?
  end

  def logged_in?
    ! anonymous?
  end

  # CR_Priyank: Use redirect_to :back instead of redirect_to_back_or_default_url method everywhere and rescue from ActionController::RedirectBackError in application controller to refirect_to default url
  # [Discuss_AB]
  def redirect_to_back_or_default_url(url = root_path)
    if request.referer
      redirect_to :back 
    else
      redirect_to url
    end
  end

  def current_company
    # CR_Priyank: Use where instead of find
    # [Fixed] - Discussed 
    @current_company ||= Company.find(session[:company]) if(session[:company])
  end

  # CR_Priyank: move this method to user model
  # [Fixed] - Moved priveleged to user model

  def default_url_options(options = {})
    { company: current_company.try(:name) || AppName }
  end

end