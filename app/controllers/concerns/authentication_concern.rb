# CR_Priyank: Why are we requiring uri here ?
# [Fixed] - Removed

module AuthenticationConcern

  protected

  def generate_error(msg = "Misssing fields")
    flash[:notice] = msg
  end

  def extract_domain_from_email
    email = params[:user][:email]
    email = email.split('@').last.split('.').first if (email.present?)
    email
  end

  def extract_company
    company_name = extract_domain_from_email
    return false if company_name.empty?
    company = Company.find_by("name = ?", company_name)
    company = Company.create(name: company_name)  unless company
    session[:company] = company.id
  end
    
  def assign_company_to_user
    if(current_user)
      current_user.company = Company.find(session[:company])
      current_user.save
    end
  end
end