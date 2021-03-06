# Settings specified here will take precedence over those in config/environment.rb

# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false