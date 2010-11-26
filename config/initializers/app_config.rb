require 'yaml'

# Load application configuration
APP_CONFIG = YAML.load_file("#{Rails.root}/config/api.yml")