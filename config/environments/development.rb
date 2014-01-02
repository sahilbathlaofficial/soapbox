AppName.constantize::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  #default url options for devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'example.com',
    user_name:            'timepass.vela@gmail.com',
    password:             '',
    authentication:       'plain',
    enable_starttls_auto: true  }

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'hemant-khemani',
      :access_key_id => 'AKIAIHK2M7O27MPRPMPA',
      :secret_access_key => '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'
    }
  }
  end
