class ControllerDevise::SessionsController < Devise::SessionsController
  include AuthenticationConcern
  layout "sign_in_sign_up"
  
  before_filter :only  => [:create] do |filter|
    filter.generate_error("Invalid email and password combination")
    filter.extract_connection
  end

  after_filter :only => :create do
    current_user.connection = Connection.find(session[:connection])
    current_user.save
  end

end
