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
    (allowed_params[:to_ban].split || []).each do |company_id|
      Company.transaction do 
        # CR_Priyank: Use where instead of find
        # [Fixed] Using find_by instead
        # CR_Priyank: What if object is not destroyed ?
        # [Fixed] Case added for destroy error
        begin
          Company.find_by(id: company_id).destroy
        rescue ActiveRecord::Rollback
          flash[:notice] = "Companies not destroyed due to some reason"
          redirect_to action: 'show'
        end
        # CR_Priyank: Fix typo
        # [Fixed]: Fixed Typo
      end
    end
    flash[:notice] = 'Changes saved for Companies'
    respond_to do |format|
      format.html { redirect_to action: 'show'}
    end
  end

end
