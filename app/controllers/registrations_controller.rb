class RegistrationsController < Devise::RegistrationsController
  # skip_load_and_authorize_resource

  def create
    build_resource
    session[:datecart_id] ||= Datecart.create.id
    resource.active_datecart_id = session[:datecart_id]
    if resource.save
      if resource.active_for_authentication?
        datecart = Datecart.find resource.active_datecart_id
        datecart.update_attribute(:user_id, resource.id)
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  private
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end

