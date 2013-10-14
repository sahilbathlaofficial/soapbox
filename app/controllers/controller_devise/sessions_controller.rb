class ControllerDevise::SessionsController < Devise::SessionsController
  include AuthenticationConcern
  layout "sign_in_sign_up"

  skip_before_action :authorize
  
  before_action :only  => [:create] do |filter|
    filter.generate_error("Invalid email and password combination")
    filter.extract_connection
  end

  after_action :only => :create do |filter|
    filter.assign_connection_to_user
  end

end
