heroku_java_home = '/usr/lib/jvm/java-6-openjdk'
ENV['JAVA_HOME'] = heroku_java_home if Dir.exist?(heroku_java_home)
ruby "1.9.3"

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
gem 'pdf-merger'
gem 'rjb'
gem 'fullcontact'
gem 'thin'


gem 'wkhtmltopdf-binary'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.1.1.0'
  gem 'bourbon'
  gem 'font-awesome-sass-rails', '~> 3.0.0.0', git: "https://github.com/nicoles/font-awesome-sass-rails.git"
  gem 'uglifier', '>= 1.0.3'
  gem 'sass-rails',   '~> 3.2.3'
end

group :development do
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'pry-rails'
end

group :development, :test do
  gem 'railroady'
end
