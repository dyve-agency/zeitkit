ruby "2.1.1"

source 'https://rubygems.org'

gem 'rails', '3.2.17'

gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'sorcery', git: 'git@github.com:NoamB/sorcery.git'


gem 'simple_form'

# Use jquery as the JavaScript library
gem 'jquery-rails', git: "https://github.com/rails/jquery-rails"

gem 'cancan'
gem 'newrelic_rpm'
gem 'redcarpet'
gem 'rack-force_domain'
gem 'money'
gem 'contact_us', '~> 0.4.0', git: "https://github.com/hendricius/contact_us.git"
gem 'pdfkit'
gem 'fullcontact'
gem 'jbuilder'
gem "permanent_records", "~> 3.1.3"
gem 'validates_email_format_of'

gem 'wkhtmltopdf-binary', git: "https://github.com/tolgap/wkhtmltopdf-binary.git"

# Managing startup behavior of App
gem 'foreman'

# Use the unicorn web server
gem 'unicorn'

# Octokit gem for github
gem 'octokit'

# Omniauth Github
gem 'omniauth'
gem 'omniauth-github'

# Use bootstrap as the style framework
gem 'bootstrap-sass', git: 'https://github.com/twbs/bootstrap-sass', tag: 'v2.3.2.2'

# Bootstrap helpers
gem "rails-bootstrap-helpers", git: "https://github.com/Tretti/rails-bootstrap-helpers.git"

# Scheduled jobs
gem "whenever"

# Mergint two pdfs
gem "prawn"

# JS precompiler
gem "therubyracer"

# Pagination
gem 'will_paginate-bootstrap', '0.2.5'

# Creating nested forms easily
gem "nested_form", git: "git@github.com:hendricius/nested_form.git"

# Creating charts
gem 'chartkick', git: "https://github.com/ankane/chartkick.git"
gem 'groupdate', git: "https://github.com/ankane/groupdate.git"

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bourbon'
  gem 'font-awesome-sass-rails', '~> 3.0.0.0', git: "https://github.com/nicoles/font-awesome-sass-rails.git"
  gem 'uglifier', '>= 1.0.3'

  # Formating times
  gem 'momentjs-rails'
end

group :development do
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'pry-rails'
end

group :development, :test do
  gem 'railroady'
end
