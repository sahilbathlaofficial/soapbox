class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize  
  before_action :set_locale
  before_action :set_current_user_thread
  helper_method :current_company
 
  protected

  def set_locale
    if(['hi','en'].include?(params[:locale]))
      I18n.locale = params[:locale] 
    else
      I18n.locale = I18n.default_locale
    end
  end

  def set_current_user_thread
    Thread.current[:user] = current_user
  end

  def authorize
    #FIXME_AB: if !(current_user) is used to check whether user is logged in or not. So define to method for that, logged_in? and annonymous?
    #[Fixed] - Made two methods for the same
    if deleted?
      sign_out @user 
      flash[:notice] = "You are banned"
    end
    redirect_to new_user_session_path if anonymous? 
  end

  def anonymous?
    current_user.nil?
  end

  def logged_in?
    ! anonymous?
  end

  def deleted?
    current_user.deleted_at? if(current_user)
  end

  def redirect_to_back_or_default_url(url = root_path)
    if request.referer
      redirect_to :back 
    else
      redirect_to url
    end
  end

  def current_company
    # CR_Priyank: Use where instead of find
    # [Fixed] - Fixed
    # CR_Priyank: Not Fixed
    # [Fixed] - Sorry sir :( - Fixed now
    @current_company ||= Company.find_by(id: session[:company]) if(session[:company])
  end


  # Company scope removed for now but may be added by user later
  # def default_url_options(options = {})
  #   { company: current_company.try(:name) || AppName }
  # end

end