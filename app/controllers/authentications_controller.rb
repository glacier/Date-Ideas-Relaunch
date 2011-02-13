class AuthenticationsController < ApplicationController
  # before_filter :authenticate_user!
  # GET /authentications
  # GET /authentications.xml
  def index
    @authentications = current_user.authentications if current_user
  end

  # POST /authentications
  # POST /authentications.xml
  # railscast episode 235 to 236
  def create    
    omniauth = request.env["omniauth.auth"]
    
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      #directly sign in existing user with existing authentication
      flash[:notice] = "signed in successfully"
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      #create a new authentication for currently signed in user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])  
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url
    else
      # user does not have an account or is authenticated through a provider
      user = User.new
      user.apply_omniauth(omniauth) 
      if user.save
        flash[:notice] = "Signed in successfully."  
        sign_in_and_redirect(:user, user)  
      else
        session[:omniauth] = omniauth.except('extra')  
        redirect_to new_user_registration_url  
      end   
    end
  end
  
  # DELETE /authentications/1
  # DELETE /authentications/1.xml
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to(authentications_url, :notice => 'Successfully destroyed authentication!') }
      format.xml  { head :ok }
    end
  end
end
