ruby "2.5.1"

source 'https://rubygems.org'

gem 'bundler'
gem 'rails', '~> 4.2.0'

gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'sorcery', git: 'https://github.com/NoamB/sorcery.git'

gem 'simple_form', git: "https://github.com/plataformatec/simple_form.git"

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'cancancan', git: "https://github.com/CanCanCommunity/cancancan.git", branch: "develop"
gem 'airbrake', '~> 6.2'
gem 'redcarpet'
gem 'rack-force_domain'
gem 'money-rails'
gem 'pdfkit', git: "https://github.com/pdfkit/pdfkit.git"
gem 'jbuilder'
gem "permanent_records", "~> 3.1.3"
gem 'validates_email_format_of'

# Necessary since 4.2.0 to use 'respond_to'
gem "responders"
gem 'contact_us', '~> 1.0.1'

# Session store and cache
gem 'redis-rails', '~> 5.0.2'
gem 'redis-store', '>= 1.4.0'

# Wkhtmltopdf
gem 'wkhtmltopdf-binary', '~> 0.9.9.3'


# Managing startup behavior of App
gem 'foreman'

# Octokit gem for github
gem 'octokit'

# Use bootstrap as the style framework
gem 'bootstrap-sass', '~> 3.3.1'
gem 'sass-rails', '>= 3.2'

# Bootstrap helpers
gem "rails-bootstrap-helpers", git: "https://github.com/Tretti/rails-bootstrap-helpers.git"

# Scheduled jobs
gem "whenever"

# Mergint two pdfs
gem "prawn"

# JS precompiler
# gem "therubyracer"

# Pagination
gem 'will_paginate-bootstrap', git: "https://github.com/bootstrap-ruby/will_paginate-bootstrap.git"

# Creating nested forms easily
gem "nested_form", git: "https://github.com/hendricius/nested_form.git"

# Creating charts
gem 'chartkick', git: "https://github.com/ankane/chartkick.git"
gem 'groupdate', git: "https://github.com/ankane/groupdate.git"

# Angular JS
gem 'angularjs-rails'
gem 'ng-rails-csrf'
gem 'angularjs-rails-resource', '~> 1.1.1'

# Data to the client
gem 'gon'

# One time Announcement
gem "starburst"

# Attr accessible
gem 'protected_attributes', github: 'rails/protected_attributes'

# Nicer service classes
gem "virtus"

# Serializers for models
gem 'active_model_serializers', git: "https://github.com/rails-api/active_model_serializers.git", branch: 'e2ded594d31fa97201c3e2fa1106708d68d86751'

# Decorators
gem 'draper', git: "https://github.com/drapergem/draper.git"

# CSS mixins
gem 'bourbon'
gem "font-awesome-rails", git: "https://github.com/bokmann/font-awesome-rails.git"

gem 'dotiw'

# Moment.js lib
gem 'momentjs-rails'

group :development do
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'uglifier'
  gem "better_errors"
  gem 'binding_of_caller'
  gem 'dotenv'
end

group :test do
  gem 'simplecov'
  gem 'rspec-rails', '~> 3.6'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
end

gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
