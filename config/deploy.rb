set :application, "DateIdeas"
set :scm, :git
set :repository,  "git@github.com:will-lam/Date-Ideas-Relaunch.git"
set :branch, "prod"

# Use single user installation settings
set :rvm_type, :user
set :rvm_ruby_string, "ruby-1.9.2-p136"

set :deploy_to, "/mnt/apps/dateideas"
set :rails_env, "production"

default_run_options[:pty] = true
set :use_sudo, false

set :user, "dateideas"
set :runner, "dateideas"


role :web, "www1.getdateideas.com"                          # Your HTTP server, Apache/et
role :app, "www1.getdateideas.com"                          # This may be the same as your `Web` server
role :db,  "www1.getdateideas.com", :primary => true # This is where Rails migrations will run


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
