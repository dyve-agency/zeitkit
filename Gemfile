heroku_java_home = '/usr/lib/jvm/java-6-openjdk'
ENV['JAVA_HOME'] = heroku_java_home if Dir.exist?(heroku_java_home)
ruby "2.0.0"

source 'https://rubygems.org'

gem 'rails', '3.2.11'

gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'sorcery', git: 'https://github.com/hendricius/sorcery.git', branch: :access_token


gem 'simple_form'
gem 'jquery-rails'
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

# Bootstrap helpers
gem "rails-bootstrap-helpers", git: "https://github.com/Tretti/rails-bootstrap-helpers.git"

# Scheduled jobs
gem "whenever"

# Mergint two pdfs
gem "prawn"

# JS precompiler
gem "therubyracer"

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bourbon'
  gem 'font-awesome-sass-rails', '~> 3.0.0.0', git: "https://github.com/nicoles/font-awesome-sass-rails.git"
  gem 'uglifier', '>= 1.0.3'

  # Use bootstrap as the style framework
  gem 'bootstrap-sass', '~> 2.3.1.1', git: 'https://github.com/thomas-mcdonald/bootstrap-sass', tag: 'v2.3.1.1'

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
