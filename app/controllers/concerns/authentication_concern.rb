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

  def extract_connection
    connection_name = extract_domain_from_email
    return false if connection_name.empty?
    connection = Connection.find_by("name=?", connection_name)
    connection = Connection.create(name: connection_name) if connection.nil?
    session[:connection] = connection.id
  end
    
  def assign_connection_to_user
    if(current_user)
      current_user.connection = Connection.find(session[:connection])
      current_user.save
      #session[:connection] = nil
    end
  end
    
end