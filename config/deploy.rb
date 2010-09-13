set :application, "sanctionwatch"
set :domain, "sanctionwatch.net"
set :repository, "git@github.com:jsboulanger/sanction-watch.git"
set :user, "root"
set :scm, :git

set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

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
