# Responsible for signing in a user
class SessionsController < Devise::SessionsController
  respond_to :js, :html
  
  def new
    resource = build_resource
    clean_up_passwords(resource)
  end

  # Copy the sessions controller here, and modify the line that redirects
  # Change it to point to the dashboard when a user successfully authenticates
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?

    # Use sign_in_and_redirect instead of sign_in to attempt to redirect to 
    # stored_location_for instead of the path defined by after_sign_in_path_for

    sign_in_and_redirect(resource_name, resource)

    # Here we have access to 'stored_location_for', which stores the location from which the user made the request.  
    # This is also stored in session['user_return_to']. See Devise doc & code
    # https://github.com/plataformatec/devise/blob/master/lib/devise/failure_app.rb
  end
  
  private

  def format_suffix
    "." + request.format.to_sym.to_s
  end

  # Fixes the redirect from xhr request problem in Firefox 
  # by appending the request format to the url to redirect to
  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    session.key?(:"#{scope}_return_to") ? session.delete(:"#{scope}_return_to") + format_suffix : nil
  end
  
end
