source 'https://rubygems.org'
ruby "2.1.7"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'


gem 'pg'

gem 'camaleon_cms'
gem 'post_reorder'

gem 'bourbon'
gem 'ionicons-rails'

gem 'decorators', '~> 2.0.1'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

## BEGIN CAMALEON GEMS (FOR HEROKU)
# These gems where copied from ./lib/Gemfile_camaleon to make the Gemfile and Gemfile.lock consistant for heroku

gem 'protected_attributes' # used for dynamic attributes (newer versions will be deprecated)
gem 'bcrypt' # rails password security
gem 'mini_magick' # image library (resize, crop, captcha, ..)
gem 'will_paginate' # list pagination
gem 'will_paginate-bootstrap' # list pagination for bootstrap

# others
gem 'el_finder' # media manager
gem 'cancancan', '~> 1.10' # user permissions
gem 'meta-tags' # seo meta tags generatos
gem 'draper', '~> 1.3' # decorators

gem 'rufus-scheduler', '~> 3.1.1' # crontab
gem "dynamic_sitemaps" # sitemaps
gem 'actionpack-page_caching' # page caching
gem 'mobu' # mobile detect

## END CAMALEON GEMS (FOR HEROKU)

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  ## BEGIN CAMALEON GEMS (FOR HEROKU)
  
  gem 'thin'
  gem 'tzinfo-data'
  
  ## END CAMALEON GEMS (FOR HEROKU)
end

gem 'rails_12factor', group: :production



#################### Camaleon CMS include all gems for plugins and themes #################### 
require './lib/plugin_routes' 
instance_eval(PluginRoutes.draw_gems)