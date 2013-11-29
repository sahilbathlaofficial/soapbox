class SiteAdmin::CompaniesController < SiteAdmin::AdminController
  
  def show
    @companies = Company.all
  end

  def manage_companies
    allowed_params = params.permit('to_ban')
    # CR_Priyank: Why are setting flash notice twice. Use conditional.
    flash[:notice] = 'Changes saved for Companies'
    flash[:notice] = 'Changes not saved for Companies' if !(Company.manage_companies(current_user, allowed_params))
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end
