# Shamelessly stolen from http://stackoverflow.com/a/14788674

require 'ostruct'
require 'yaml'

APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]
