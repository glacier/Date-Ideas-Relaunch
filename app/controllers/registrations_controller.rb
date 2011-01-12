class RegistrationsController < Devise::RegistrationsController
  # overrides the create method of the devise registration controller to link in user profile
  def create
      build_resource
  
      if resource.save
        if resource.active?
          set_flash_message :notice, :signed_up
          sign_in(resource_name, resource)
          # redirect to new profile creation
          logger.debug("Grace: RegistrationController: redirect to profile/new")
          redirect_to new_profile_path :user_id => resource
        else
          set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
          expire_session_data_after_sign_in!
          redirect_to after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords(resource)
        render_with_scope :new
      end
  end
end

