require 'uri'

module AuthenticationConcern

  protected

  def generate_error(msg = "Misssing fields")
    flash[:notice] = msg
  end

  def extract_domain_from_email
    email = params[:user][:email]
    email = email.split('@').last.split('.').first if !(email.empty?)
    email
  end

  def extract_company
    company_name = extract_domain_from_email
    return false if company_name.empty?
    company = Company.find_by("name=?", company_name)
    if company.nil?
      company = Company.create(name: company_name) 
      company.groups << Group.new(name: company_name.downcase)
    end
    session[:company] = company.id
  end
    
  def assign_company_to_user
    if(current_user)
      current_user.company = Company.find(session[:company])
      current_user.save
      #session[:company] = nil
    end
  end

  def provide_dummy_names
    if(current_user)
      current_user.firstname = 'vTweet User'
      current_user.lastname = current_user.id.to_s
      current_user.save
    end
  end

  def join_default_group
    current_user.groups << Group.find_by(name: current_user.company.name.downcase)
  end
    
end