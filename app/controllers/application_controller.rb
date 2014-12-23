class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Sets a different layout for each devise resource.
  layout :layout_by_resource

  protected

    # Sets a different layout for each devise resource.
    def layout_by_resource
      if devise_controller?
        if resource_name == :admin
          "devise_admin_application" # admin model will use this layout.
        elsif resource_name == :employee
          "devise_employee_application" # employee model will use this layout.
        else
          "devise_application" # any other devise model will use this layout.
        end
      else
        "application" # default rails application layout.
      end
    end

    # Configures mass assignment rules for the devise controllers
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:login) {
          |u| u.permit(:login)
      }
      devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(:email,
                       :username,
                       :password,
                       :password_confirmation)
      }
      devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(:username,
                       :email,
                       :password,
                       :password_confirmation,
                       :current_password) }
    end
end
