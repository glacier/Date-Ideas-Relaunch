class RelationshipsController < ApplicationController
  def create
      @user = User.find params[:relationship][:followed_id]
      current_user.follow!(@user)
      respond_to do |format|
        format.html { redirect_to @user, :notice => "Successfully following #{@followed.user_name}!"}
        format.js
      end
  end
  
  def destroy
    #get the followed user's user model object -- @user
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end