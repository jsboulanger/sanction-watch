set :application, "sanctionwatch"
set :domain, "sanctionwatch.net"
set :repository, "http://svn.jsboulanger.com/sanction-watch/trunk/"
set :user, "root"
#set :repository,  "set your repository location here"

set :use_sudo, false
set :deploy_to, "/var/www/#{application}"

set :scm_username, "capistrano"
set :scm_password, ""

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
  run "ln -s #{shared_path}/data #{release_path}/data"
end
after "deploy:update_code", :update_config