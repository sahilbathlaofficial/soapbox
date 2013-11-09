class SiteAdmin::CompaniesController < SiteAdmin::AdminController
  def show
    @companies = Company.all
  end

  def destroy_companies
   allowed_params = params.permit('to_ban')
   allowed_params[:to_ban].split.each do |company_id|
     Company.find(company_id).destroy
     flash[:notice]= 'Comapnies Destroyed'
      respond_to do |format|
        format.html { redirect_to action: 'show'}
      end
   end
  end
end
