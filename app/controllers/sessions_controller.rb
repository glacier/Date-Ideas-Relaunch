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
    
    # redirect to requested actions made prior to sign in / sign up 
    if params[:user][:do_action] == "save"
      y request.referer
      redirect_to request.referer
    elsif params[:user][:do_action] == "email"
      redirect_to "/datecarts/#{params[:user][:datecart_id]}/email"
    else
      redirect_to :dashboard
    end
  end
end
