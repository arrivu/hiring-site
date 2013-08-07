server "arrivuapps.com", :app, :web, :db, :primary => true
set :deploy_to, "/var/capistrano/deploy/lms"
set :branch,    "deploy"
#set :scm_passphrase, "deployadmin123$"
set :smart_lms_data_files, "#{deploy_to}/data/files"
set :ping_url, "https://www.arrivuapps.com/login"
set :ssh_options[:port] = "2002"
