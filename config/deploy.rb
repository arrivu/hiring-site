require "bundler/capistrano"
require "capistrano/ext/multistage"

set :application,   "smart-lms"
set :user,    "sysadmin"
set :passenger_user,"canvasuser"

set :stages, ["testing","staging", "production"]
set :default_stage, "testing"

set :scm,     :git
set :deploy_via,  :remote_cache
set :branch,        "deploy"
set :deploy_to,     "/var/capistrano/deploy/lms"
set :use_sudo,      true
set :deploy_env,    "deploy"
#set :bundle_dir,    "/var/data/gems"
set :bundle_without, []
#set me for future
set :ping_url, "https://arrivuhiring.com/login"

def is_hotfix?
  ENV.has_key?('hotfix') && ENV['hotfix'].downcase == "true"
end

disable_log_formatters;

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa_canvas")]

set :rake, "#{rake} --trace"
set :bundle_without, []
#set :bundle_without, [:development, :test]

task :uname do
  run 'uname -a'
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :cleanup, :except => { :no_release => true } do
    count = fetch(:keep_releases, 5).to_i
    sudo "ls -1dt #{releases_path}/* | tail -n +#{count + 1} | xargs rm -rf"
  end


  namespace :web do
    task :disable, :roles => :app do
      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      run "cp /usr/local/deployment/maintenance.html #{shared_path}/system/maintenance.html && chmod 0644 #{shared_path}/system/maintenance.html"
    end

    task :enable, :roles => :app do
      run "rm #{shared_path}/system/maintenance.html"
    end
  end
end

# Canavs-specific task after a deploy
namespace :canvas do

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  # LOCAL COMMANDS
  desc "Update the deploy branch of the local repo"
  task :update do
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

  #desc "Create symlink for files folder to mount point"
  #task :symlink_canvasfiles do
  #    target = "mnt/data"
  #    run "mkdir -p #{latest_release}/#{target} && ln -s #{data_dir}/canvasfiles #{latest_release}/#{target}/canvasfiles"
  #end

  # On every deploy
  desc "Create symlink for files folder to mount point"
  task :copy_config do
    folder = 'tmp/files'
    run "ln -nfs #{smart_lms_data_files} #{latest_release}/#{folder}"
    run "ln -nfs #{shared_path}/config/cache_store.yml #{release_path}/config/cache_store.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/delayed_jobs.yml #{release_path}/config/delayed_jobs.yml"
    run "ln -nfs #{shared_path}/config/domain.yml #{release_path}/config/domain.yml"
    run "ln -nfs #{shared_path}/config/file_store.yml #{release_path}/config/file_store.yml"
    run "ln -nfs #{shared_path}/config/logging.yml #{release_path}/config/logging.yml"
    run "ln -nfs #{shared_path}/config/outgoing_mail.yml #{release_path}/config/outgoing_mail.yml"
    run "ln -nfs #{shared_path}/config/redis.yml #{release_path}/config/redis.yml"
    run "ln -nfs #{shared_path}/config/security.yml #{release_path}/config/security.yml"
  end

  desc "Clone QTIMigrationTool"
  task :clone_qtimigrationtool do
    run "cd #{latest_release}/vendor && git clone https://github.com/instructure/QTIMigrationTool.git QTIMigrationTool && chmod +x QTIMigrationTool/migrate.py"
  end

  desc "Clone canvas-mt"
  task :clone_canvas_mt do
    run "cd #{latest_release}/vendor/plugins && git clone -b #{branch} git@github.com:m-narayan/canvas-mt.git canvas_mt"
  end

  desc "Clone lms_customization"
  task :clone_lms_customization do
    run "cd #{latest_release}/vendor/plugins && git clone -b #{branch} git@github.com:m-narayan/lms_customization.git lms_customization"
  end

  desc "Compile static assets"
  task :compile_assets, :on_error => :continue do
    # On remote: bundle exec rake canvas:compile_assets
    run "cd #{latest_release} && bundle exec #{rake} RAILS_ENV=#{rails_env} canvas:compile_assets[false]"
    # run "cd #{latest_release} && chown -R #{passenger_user}:#{passenger_user} ."
  end

  desc "Load new notification types"
  task :load_notifications, :roles => :db, :only => { :primary => true } do
    # On remote: RAILS_ENV=production bundle exec rake db:load_notifications
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:load_notifications --quiet"
  end



  desc "Restarted delayed jobs workers"
  task :restart_jobs, :on_error => :continue do
    sudo "touch #{current_path}/tmp/restart.txt"
    # On remote: /etc/init.d/canvas_init restart
    sudo "/etc/init.d/canvas_init restart"
  end

  desc "Tasks that run before create_symlink"
  task :before_create_symlink do
    clone_qtimigrationtool
    clone_canvas_mt
    clone_lms_customization
    copy_config
    compile_assets
    canvasuser_permission
  end

  desc "change permission to canvasuser "
  task :canvasuser_permission, :on_error => :continue do
    sudo "mkdir -p #{current_path}/log #{current_path}/tmp/pids #{current_path}/public/assets #{current_path}/public/stylesheets/compiled"
    sudo "touch Gemfile.lock"
    sudo "chown -R canvasuser #{current_path}/config/environment.rb #{current_path}/log #{current_path}/tmp #{current_path}/public/assets #{current_path}/public/stylesheets/compiled #{current_path}/Gemfile.lock #{current_path}/config.ru"
  end

  desc "Tasks that run after create_symlink"
  task :after_create_symlink do
    deploy.migrate unless is_hotfix?
    load_notifications unless is_hotfix?
  end

  desc "Tasks that run after the deploy completes"
  task :after_deploy do
    restart_jobs
    puts "\x1b[42m\x1b[1;37m Deploy complete!  \x1b[0m"
  end
end

#Monit tasks
namespace :monit do
  task :start do
    sudo 'monit'
  end
  task :stop do
    sudo 'monit quit'
  end
end

# Add this to add the `deploy:ping` task:
namespace :deploy do
  task :ping do
    system "curl --silent #{fetch(:ping_url)}"
  end
end

before(:deploy, "canvas:check_revision")
before(:deploy, "deploy:web:disable") unless is_hotfix?
before("deploy:create_symlink", "canvas:before_create_symlink")
after("deploy:create_symlink", "canvas:after_create_symlink")
after(:deploy, "canvas:after_deploy")
after(:deploy, "deploy:cleanup")
after(:deploy, "deploy:web:enable") unless is_hotfix?

# Stop Monit during restart
before 'deploy:restart', 'monit:stop'
after 'deploy:restart', 'monit:start'

# Add this to automatically ping the server after a restart:
after "deploy:restart", "deploy:ping"

#before(:deploy, "canvas:check_user")
# # UTILITY TASKS
# desc "Make sure that only the deploy user can run certain tasks"
# task :check_user do
#   transaction do
#     do_check_user
#   end
# end

# desc "Make sure that only the deploy user can run certain tasks"
# task :do_check_user do
#   on_rollback do
#     puts "\x1b[41m\x1b[1;37m Please run this command as '#{user}' user \x1b[0m"
#   end
#   run_locally "[ `whoami` == #{user} ]"
  # end







# amazon_s3.yml
# cache_store.yml
# database.yml
# delayed_jobs.yml
# domain.yml
# external_migration.yml
# file_store.yml
# logging.yml
# outgoing_mail.yml
# redis.yml
# security.yml


# cap bundle:install            # Install the current Bundler environment.
# cap canvas:check_user         # Make sure that only the deploy user can run certain tasks
# cap canvas:compile_assets     # Compile static assets
# cap canvas:do_check_user      # Make sure that only the deploy user can run certain tasks
# cap canvas:files_symlink      # Create symlink for files folder to mount point
# cap canvas:load_notifications # Load new notification types
# cap canvas:restart_jobs       # Restarted delayed jobs workers
# cap canvas:update             # Update the deploy branch of the local repo
# cap canvas:update_gems        # Install new gems from bundle and push updates
# cap canvas:update_remote      # Post-update commands
# cap deploy                    # Deploys your project.
# cap deploy:check              # Test deployment dependencies.
# cap deploy:check_revision     # Make sure local git is in sync with remote.
# cap deploy:cleanup            # Clean up old releases.
# cap deploy:cold               # Deploys and starts a `cold' application.
# cap deploy:create_symlink     # Updates the symlink to the most recently deployed version.
# cap deploy:migrate            # Run the migrate rake task.
# cap deploy:migrations         # Deploy and run pending migrations.
# cap deploy:pending            # Displays the commits since your last deploy.
# cap deploy:pending:diff       # Displays the `diff' since your last deploy.
# cap deploy:rollback           # Rolls back to a previous version and restarts.
# cap deploy:rollback:code      # Rolls back to the previously deployed version.
# cap deploy:setup              # Prepares one or more servers for deployment.
# cap deploy:symlink            # Deprecated API.
# cap deploy:update             # Copies your project and updates the symlink.
# cap deploy:update_code        # Copies your project to the remote servers.
# cap deploy:upload             # Copy files to the currently deployed version.
# cap deploy:web:disable        # Present a maintenance page to visitors.
# cap deploy:web:enable         # Makes the application web-accessible again.
# cap invoke                    # Invoke a single command on the remote servers.
# cap multistage:prepare        # Stub out the staging config files.
# cap production                # Set the target stage to `production'.
# cap shell                     # Begin an interactive Capistrano session.
# cap staging                   # Set the target stage to `staging'.
