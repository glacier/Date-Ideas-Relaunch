class SessionsController < Devise::SessionsController

  def new
    resource = build_resource
    clean_up_passwords(resource)
  end

  # Copy the sessions controller here, and modify the line that redirects
  # Change it to point to the dashboard when a user successfully authenticates
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    
    y params
    
    redirect_to :dashboard
  end
end
