class ControllerDevise::RegistrationsController < Devise::RegistrationsController
  include AuthenticationConcern
  skip_before_action :authorize
  before_action :only => :create do |filter|
    filter.generate_error("Sign Up error")
    filter.configure_permitted_parameters
    filter.extract_connection
  end

  after_action :only => :create do |filter|
    filter.assign_connection_to_user
    filter.provide_dummy_names
    filter.join_default_group
  end


  layout "sign_in_sign_up"

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :confirm_passwords) }
    end

end