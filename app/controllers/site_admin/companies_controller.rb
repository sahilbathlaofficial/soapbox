# CR_Priyank: Indent properly
class SiteAdmin::CompaniesController < SiteAdmin::AdminController
  
  def show
    @companies = Company.all
  end

  def manage_companies
  # CR_Priyank: I think we shall use require instead of permit here and handle exception accordingly
  allowed_params = params.permit('to_ban')
  allowed_params[:to_ban].split.each do |company_id|
    # CR_Priyank: Use where instead of find
    # CR_Priyank: What if object is not destroyed ?
    Company.find(company_id).destroy
     # CR_Priyank: Fix typo
      flash[:notice]= 'Companies Destroyed'
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
   end
  end
end
