# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
config.breakpoint_server = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
# キャッシュを作る
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# キャッシュファイル保存場所　 (デフォルトは RAILS_ROOT+'/public')
#config.action_controller.page_cache_directory = '/usr/local/site/bokukoyo/html'

config.log_level = :debug

DOMAIN = "bokukoyo-test.drecom.jp"

APP_CONFIG = {
  :domain => DOMAIN,
  :url => "http://#{DOMAIN}:3000/",
  :mfps_host => "mfps.drecom.jp",
  :mfps_port => 80,
  :request => "/api/hCalendar",
  :hcalendar_url => "http://#{DOMAIN}:3000/for_neko/",
  :ping_name => "ぼくこよ",
  :ping_url => "http://mfps.drecom.jp/xmlrpc",
  :ping_from_url => "http://#{DOMAIN}:3000/for_neko/",
  :storage_path => "/Users/ebisen/ruby/bokukoyo/public/for_neko/"
}
