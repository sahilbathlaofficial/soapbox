require 'uri'

module AuthenticationConcern

  protected

  def generate_error(msg = "Misssing fields")
    flash[:notice] = msg
  end


  def extract_connection
    connection_name= params[:user][:email].split("@").last.split(".").first
    connection = Connection.find_by("name=?", connection_name)
    connection = Connection.create(name: connection_name) if connection.nil?
    session[:connection] = connection.id
  end
    
end