# CR_Priyank: Indent properly
# [Fixed] - Done so
class SiteAdmin::CompaniesController < SiteAdmin::AdminController
  
  def show
    @companies = Company.all
  end

  def manage_companies
    # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
    # [Fixed] Handled the case in case no to_ban is added
    allowed_params = params.permit('to_ban')
    flash[:notice] = 'Changes saved for Companies'
    flash[:notice] = 'Changes not saved for Companies' if !(Company.manage_companies(current_user, allowed_params))
    # CR_Priyank: Fix typo
    # [Fixed]: Fixed Typo
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end
