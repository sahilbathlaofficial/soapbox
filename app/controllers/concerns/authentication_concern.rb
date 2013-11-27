require 'uri'

module AuthenticationConcern

  protected

  def generate_error(msg = "Misssing fields")
    flash[:notice] = msg
  end

  def extract_domain_from_email
    email = params[:user][:email]
    # CR_Priyank: we can also use email.present?
    # [Fixed] - using present
    email = email.split('@').last.split('.').first if (email.present?)
    email
  end

  def extract_company
    # CR_Priyank: Improve logic below, also I am not sure why we are extracting from user's email. So if user's email is abc@gmail.com then we will end up creating a company named as gmail
    #[Discuss_AB]
    company_name = extract_domain_from_email
    return false if company_name.empty?
    company = Company.find_by("name = ?", company_name)
    company = Company.create(name: company_name)  if company.nil?
    session[:company] = company.id
  end
    
  def assign_company_to_user
    if(current_user)
      current_user.company = Company.find(session[:company])
      current_user.save
    end
  end

  # CR_Priyank: Must be moved in model
  # [Fixed] - Moved to User model

  # Must be moved in model's concern
  # [Fixed]
    
end