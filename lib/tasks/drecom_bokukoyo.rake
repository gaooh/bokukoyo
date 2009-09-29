require 'tempfile'

namespace :drecom do
  # drecom bokukoyo tasks
  namespace :bokukoyo do
    desc "install drecom bokukoyo"
    task :install => [:install_files, :migrate_with_cluster] do
    end

    desc "initialize files for drecom bokukoyo."
    task :install_files do
      puts "./script/* to executable."
      FileUtils.chmod_R(0777, 'script/', :verbose => true)
      FileUtils.chmod(0777, 'public/dispatch.fcgi', :verbose => true)

      puts "create config files from examples."
      Dir["config/*.example"].each do |file|
        FileUtils.cp(file, file.gsub(/\.example$/,""), :verbose => true)
      end
    end

    desc "install cron jobs"
    task :install_cron => [:environment, :uninstall_cron] do
      tmp = Tempfile.new('drecom_bokukoyo-cron')
      output = `crontab -l`
      output = "" if output =~ /no crontab for/
      output << %Q{
#drecom chat task start
#{rake_cron("40 * * * * ", "drecom:bokukoyo:db:delete_sessions")}
#drecom bokukoyo task end
      }
      io = tmp.open
      io.write(output.strip)
      tmp.close
      `crontab #{tmp.path}`
    end

    task :uninstall_cron do
      tmp = Tempfile.new('drecom_bokukoyo-cron')
      output = `crontab -l`
      output = "" if output =~ /no crontab for/
      output.gsub!(/(\#drecom bokukoyo task start).*(\#drecom bokukoyo task end)/m,"")
      io = tmp.open
      io.write(output.strip)
      tmp.close
      `crontab #{tmp.path}`
    end

    task :app_environment => :environment do
      require "#{RAILS_ROOT}/app/controllers/application.rb"
    end

    # database tasks
    namespace :db do
      desc "migration with the active record cluster."
      task :migrate_with_cluster => [:app_environment, :migrate] do
      end

      desc "update database with active record cluster."
      task :update_with_cluster => :app_environment do
        ENV['VERSION'] = '0'
        Rake::Task[:migrate].invoke
        Rake::Task.tasks.each do|task|
          task.instance_variable_set(:@already_invoked, false)
        end
        ENV.delete('VERSION')
        Rake::Task[:migrate].invoke
      end

      desc "delete sessions after 3 hours from the last updated time."
      task :delete_sessions => :environment do
        CGI::Session::ActiveRecordStore::Session.delete_all(
          ["updated_at < ?", 3.hours.ago ])
      end

    end

    # remote tasks
    namespace :remote do
      desc "hot deploy the application to remote servers. [SVN_TAG=tag]"
      task :hot_deploy => :environment do
        half = app_servers.size / 2
        first_apps  = app_servers[0, half]
        second_apps = app_servers[half, app_servers.size]

        drecom_bokukoyo_lighttpd(first_apps, :stop)
        drecom_bokukoyo_svn_co(first_apps)
        drecom_bokukoyo_rails(first_apps, :restart)
        drecom_bokukoyo_lighttpd(first_apps, :start)

        drecom_bokukoyo_lighttpd(second_apps, :stop)
        drecom_bokukoyo_svn_co(web_servers)

        drecom_bokukoyo_svn_co(second_apps)
        drecom_bokukoyo_rails(second_apps, :restart)
        drecom_bokukoyo_lighttpd(second_apps, :start)
      end
    end
  end
end

def drecom_bokukoyo_lighttpd(servers, cmd = :stop)
  execute(servers, scm_user) do |server|
    console.su(root_user)
    console >> "/etc/init.d/drecom-lighttpd #{cmd}"
  end
end

def drecom_bokukoyo_svn_co(servers)
  $drecom_bokukoyo_svn_version ||= Time.now.to_i
  execute(servers, scm_user) do |server|
    checkout($drecom_bokukoyo_svn_version)
  end
  $current_release ||= get_current_release
  execute(servers, scm_user) do |server|
    console >> "ln -nfs #{$current_release} #{full_current_path}"
    console >> "rm -rf  #{$current_release}/log"
    console >> "ln -nfs #{full_log_path} #{$current_release}/log "
    console >> "chmod -R 777  #{$current_release}/tmp"
  end
end

def drecom_bokukoyo_rails(servers, cmd = :restart)
  execute(servers, scm_user) do |server|
    console.su(root_user)
    console >> "/etc/init.d/drecom-rails #{cmd}"
  end
end

def rake_cron(cond, command)
  if RAILS_ENV == "production"
    path = RAILS_ROOT.dup.gsub(/releases\/\d+/, "current")
  else
    path = RAILS_ROOT
  end
  "#{cond} cd #{path} && rake environment RAILS_ENV=#{RAILS_ENV} #{command}"
end
