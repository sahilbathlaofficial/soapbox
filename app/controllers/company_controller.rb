class CompanyController < ApplicationController
  before_filter :set_company, only: [:show]

  def show
    #FIXME_AB: You have a before_filter authorize so how can an anonymous user access this action
    if !(current_user)
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
    end
  end

  protected

  def set_company
    if(current_user && current_user.company)
      @company = current_user.company
    else
      #FIXME_AB: Whenever you redirect you should add a flash message(some cases may be excluded). Its a good practice 
      redirect_to new_user_session_path
    end
  end

end
