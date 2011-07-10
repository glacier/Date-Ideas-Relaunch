class Authentication < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :uid, :provider

  def provider_name  
    if provider == 'open_id'  
      "OpenID"  
    else  
      provider.titleize  
    end  
  end
end
