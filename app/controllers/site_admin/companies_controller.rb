class SiteAdmin::CompaniesController < SiteAdmin::AdminController
  
  def show
    @companies = Company.all
  end

  def manage_companies
    allowed_params = params.permit('to_ban')
    # CR_Priyank: Why are setting flash notice twice. Use conditional.
    # [Fixed] - Ok sir fixed
    if (Company.manage_companies(current_user, allowed_params))
      flash[:notice] = 'Changes saved for Companies'
    else
      flash[:notice] = 'Changes not saved for Companies'
    end
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end
