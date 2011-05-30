set :application, "DateIdeas"
set :scm, :git
set :repository,  "git@github.com:will-lam/Date-Ideas-Relaunch.git"
set :branch, "deploy"

# Use single user installation settings
set :rvm_type, :user
set :rvm_ruby_string, "ruby-1.9.2-p136"

set :deploy_to, "/mnt/apps/dateideas"
set :deploy_via, :remote_cache
set :rails_env, "production"

default_run_options[:pty] = true
set :use_sudo, true

set :default_environment, {
  'PATH' => "/home/dateideas/.rvm/bin:/home/dateideas/.rvm/gems/ruby-1.9.2-p136/bin:/home/dateideas/.rvm/gems/ruby-1.9.2-p136@global/bin:/home/dateideas/.rvm/rubies/ruby-1.9.2-p136/bin:/usr/local/bin:/usr/bin:/bin:/usr/games",
  'RUBY_VERSION' => "1.9.2p136",
  "GEM_HOME" => "/home/dateideas/.rvm/gems/ruby-1.9.2-p136",
  "GEM_PATH" => "/home/dateideas/.rvm/gems/ruby-1.9.2-p136:/home/dateideas/.rvm/gems/ruby-1.9.2-p136@global"
}

set :user, "dateideas"
set :runner, "dateideas"


role :web, "www1.getdateideas.com"                          # Your HTTP server, Apache/et
role :app, "www1.getdateideas.com"                          # This may be the same as your `Web` server
role :db,  "www1.getdateideas.com", :primary => true # This is where Rails migrations will run


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  
  task :start do 
    run "cd /mnt/apps/dateideas/current/ ; rvmsudo passenger start -p80 -eproduction -d --user=dateideas --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid --log-file /mnt/apps/dateideas/shared/log/passenger.log"
  end

  task :stop do 
    run "rvmsudo passenger stop -p80 --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "rvmsudo passenger stop -p80 --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid"
    run "cd /mnt/apps/dateideas/current/ ; rvmsudo passenger start -p80 -eproduction -d --user=dateideas --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid --log-file /mnt/apps/dateideas/shared/log/passenger.log"
  end
end



