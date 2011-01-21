require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'YcwKbd2Zeyz952IV02Wg', 'pPXZs799YiGBj401fQ4dcKGLTwvQ1KT2NnBQdzERg'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
  # provider :facebook, 'APP_ID', 'APP_SECRET'
  # provider :open_id, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end