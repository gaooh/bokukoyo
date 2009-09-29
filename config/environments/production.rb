# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

config.log_level = :error

DOMAIN = "bokukoyo.drecom.jp"

APP_CONFIG = {
  :domain => DOMAIN,
  :url => "http://#{DOMAIN}:3000/",
  :mfps_host => "mfps.drecom.jp",
  :mfps_port => 80,
  :request => "/api/hCalendar",
  :hcalendar_url => "http://#{DOMAIN}/for_neko/",
  :ping_name => "ぼくこよ",
  :ping_url => "http://mfps.drecom.jp/xmlrpc",
  :ping_from_url => "http://#{DOMAIN}/for_neko/",
  :storage_path => "/usr/local/site/bokukoyo/current/public/for_neko/"
}