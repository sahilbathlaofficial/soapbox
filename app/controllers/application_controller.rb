class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize  

  protected


  def authorize
    #FIXME_AB: if !(current_user) is used to check whether user is logged in or not. So define to method for that, logged_in? and annonymous?
    #[Fixed]
    redirect_to new_user_session_path if anonymous?
    ## code for inserting company name to url ##
    # if(logged_in? && request.method.downcase == 'get')
    #   if !(request.path_parameters[:name] == current_company.name)
    #     if request.path_parameters[:name].nil?
    #       redirect_to '/' + current_company.name + request.path 
    #     else
    #       # if any other name then com name
    #       redirect_to request.path.sub(request.path_parameters[:name], current_company.name)
    #     end
    #   end
    # end
  end

  def anonymous?
    current_user.nil?
  end

  def logged_in?
    ! anonymous?
  end

  def redirect_to_back_or_default_url(url = root_path)
    if request.referer
      redirect_to :back 
    else
      redirect_to url
    end
  end

  def current_company
    @current_company ||= Company.find(session[:company]) if(session[:company])
  end

  helper_method :current_company 

end