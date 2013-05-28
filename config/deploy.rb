require "bundler/capistrano"
require "capistrano/ext/multistage"

set :application,   "smart-lms"
set :user,    "sysadmin"
set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :repository,    "git@github.com:m-narayan/canvas-lms.git"
set :scm,     :git
set :deploy_via,  :remote_cache
set :deploy_to,   "/var/deploy/lms"
set :use_sudo,    false

set :stages, ["staging", "production"]
set :default_stage, "staging"

task :uname do
  run 'uname -a'
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Canavs-specific task after a deploy
namespace :canvas do
  
  # LOCAL COMMANDS
  desc "Update the deploy branch of the local repo"
  task :update do
    check_user
    stashResponse = run_locally "git stash"
    puts stashResponse
    puts run_locally "git checkout vendor"
    puts run_locally "git fetch"
    puts run_locally "git merge upstream/stable"
    puts run_locally "git checkout master"
    puts run_locally "git stash pop" unless stashResponse == "No local changes to save\n"
    puts "\x1b[42m\x1b[1;37m Update successful. You should now run 'git merge vendor' then 'cap canvas:update_gems' \x1b[0m"
  end
  
  desc "Install new gems from bundle and push updates"
  task :update_gems do
    check_user
    stashResponse = run_locally "git stash"
    puts stashResponse
    puts run_locally "bundle install"  #--path path=~/gems"
    puts run_locally "git add Gemfile.lock"
    puts run_locally "git commit --allow-empty Gemfile.lock -m 'Add Gemfile.lock for deploy #{release_name}'"
    puts run_locally "git push origin"
    puts run_locally "git stash pop" unless stashResponse == "No local changes to save\n"
    puts "\x1b[42m\x1b[1;37m Push sucessful. You should now run cap deploy and cap canvas:update_remote \x1b[0m"
  end

  # REMOTE COMMANDS

  # On every deploy
  desc "Create symlink for files folder to mount point"
  task :files_symlink do
    folder = 'tmp/files'
    run "ln -s #{smart_lms_data_files} #{latest_release}/#{folder}"
  end

  desc "Compile static assets"
  task :compile_assets, :on_error => :continue do
    # On remote: bundle exec rake canvas:compile_assets
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} canvas:compile_assets --quiet"
    run "cd #{latest_release} && chown -R canvas:canvas ."
  end


  # Updates only
  desc "Post-update commands"
  task :update_remote do
    deploy.migrate
    load_notifications
    restart_jobs
    puts "\x1b[42m\x1b[1;37m Deploy complete!  \x1b[0m"
  end

  desc "Load new notification types"
  task :load_notifications, :roles => :db, :only => { :primary => true } do
    # On remote: RAILS_ENV=production bundle exec rake db:load_notifications
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:load_notifications --quiet"
  end
  
  desc "Restarted delayed jobs workers"
  task :restart_jobs, :on_error => :continue do
    # On remote: /etc/init.d/canvas_init restart
    run "/etc/init.d/canvas_init restart"
  end
  
  # UTILITY TASKS
  desc "Make sure that only the deploy user can run certain tasks"
  task :check_user do
    transaction do 
      do_check_user
    end
  end

  desc "Make sure that only the deploy user can run certain tasks"
  task :do_check_user do
    on_rollback do
      puts "\x1b[41m\x1b[1;37m Please run this command as '#{user}' user \x1b[0m"
    end
    run_locally "[ `whoami` == #{user} ]"
  end
end

after(:deploy, "deploy:cleanup")
#before(:deploy, "canvas:check_user")
before("deploy:restart", "canvas:files_symlink")
before("deploy:restart", "canvas:compile_assets")














########################################
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "Myapp"

set :scm, :git
set :repository, "git@github.com:m-narayan/beacon.git"
set :branch, "capistrano"
set :deploy_via, :remote_cache
set :scm_passphrase, "deployadmin123$"

set :user, "sysadmin"
set :use_sudo, false

set :stages, ["staging", "production"]
set :default_stage, "staging"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

#set :bundle_flags, "--quiet"

namespace :deploy do
  task :start do; end
  task :stop do; end
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

after 'deploy:update_code', 'deploy:migrate'
