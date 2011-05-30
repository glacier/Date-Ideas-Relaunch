set :application, "DateIdeas"
set :scm, :git
set :repository,  "git@github.com:will-lam/Date-Ideas-Relaunch.git"
set :branch, "deploy"

# Use single user installation settings
set :rvm_ruby_string, "ruby-1.9.2-p180"

set :deploy_to, "/mnt/apps/dateideas"
set :deploy_via, :remote_cache
set :rails_env, "production"

default_run_options[:pty] = true
set :use_sudo, true

set :default_environment, {
  "PATH" => "/usr/local/rvm/gems/ruby-1.9.2-p180/bin:/usr/local/rvm/gems/ruby-1.9.2-p180@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p180/bin:/usr/local/rvm/bin:/home/dateideas/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/games",
  "RUBY_VERSION" => "1.9.2p180",
  "GEM_HOME" => "/usr/local/rvm/gems/ruby-1.9.2-p180",
  "GEM_PATH" => "/usr/local/rvm/gems/ruby-1.9.2-p180:/usr/local/rvm/gems/ruby-1.9.2-p180@global",
  "MY_RUBY_HOME" => "/usr/local/rvm/rubies/ruby-1.9.2-p180"
}

set :user, "dateideas"
set :runner, "dateideas"
set :admin_runner, "dateideas"

role :web, "www1.getdateideas.com"                          # Your HTTP server, Apache/et
role :app, "www1.getdateideas.com"                          # This may be the same as your `Web` server
role :db,  "www1.getdateideas.com", :primary => true # This is where Rails migrations will run

namespace :deploy do
  
  task :start do 
    init_sudo
    run "cd /mnt/apps/dateideas/current/ ; rvmsudo passenger start -p80 -eproduction -d --user=dateideas --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid --log-file /mnt/apps/dateideas/shared/log/passenger.log"
  end

  task :stop do 
    init_sudo
    run "rvmsudo passenger stop -p80 --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    init_sudo
    run "rvmsudo passenger stop -p80 --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid"
    run "cd /mnt/apps/dateideas/current/ ; rvmsudo passenger start -p80 -eproduction -d --user=dateideas --pid-file /mnt/apps/dateideas/shared/pids/passenger.80.pid --log-file /mnt/apps/dateideas/shared/log/passenger.log"
  end
end

task "init_sudo" do
  run "echo jErDhw65vDmO1t | sudo -S echo 'init sudo'"
end

before "deploy:migrate" do
  backup
end

task "backup", :roles => :db, :only => { :primary => true }  do
  time = Time.new.strftime("%F-%R")
  filename = "#{application}-capdump.#{time}.sql.gz"
  db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__),'database.yml'))).result)["production"]
  out_dir = "/mnt/apps/dateideas/shared/backups"
  run "mkdir -p #{out_dir}"
  run "mysqldump -u#{db['username']} -p#{db["password"]} #{db["database"]} | gzip -c > #{out_dir}/#{filename}"
end

