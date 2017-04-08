require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webchat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

ActiveRecord::SessionStore::Session.table_name = 'sessions'
ActiveRecord::SessionStore::Session.primary_key = 'session_id'
ActiveRecord::SessionStore::Session.data_column_name = 'data'
ActiveRecord::SessionStore::Session.serializer = :json
