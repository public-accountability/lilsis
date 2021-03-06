source 'https://rubygems.org'

gem 'rails', '6.1.3.2'

gem 'pg'
gem 'mysql2', '~> 0.5.2'
gem 'puma', '>= 5'
gem 'redis'

# Utilities
gem 'bootsnap', '>= 1.4.3', require: false
gem 'concurrent-ruby', require: 'concurrent'
gem 'nokogiri'
gem 'parallel'
gem 'zeitwerk'
gem 'rexml'

# Rack middleware
gem 'rack-rewrite', '~> 1.5.1'

# users and authentication
gem 'devise', '~> 4.7'

# Versioning
gem 'paper_trail', '~> 11'

# Generate versioned Postgres views
gem 'scenic'

# Pagination
gem 'kaminari'

# Delayed job
gem 'daemons' # Required by delayed_job
gem 'delayed_job', '~> 4.1'
gem 'delayed_job_active_record', '>= 4.1.3'

# Assets and images
gem 'bootstrap', '~> 4'
gem 'image_processing'
gem 'mini_magick'
gem 'sassc-rails'
gem 'sprockets', '~> 3.0'
gem 'webpacker', '>= 4.0.2'

# Search
gem 'thinking-sphinx', '~> 5.1'
gem 'ts-delayed-delta', '2.1.0', :require => 'thinking_sphinx/deltas/delayed_delta'

# handle currencies etc
gem 'money'

gem 'datagrid'

gem 'validate_url', '>= 1.0.13'

# used for screenshot capture
gem 'selenium-webdriver', '>= 3.11.0'

# Used by StringSimilarity
gem 'text', '>= 1.3.1'

gem 'httparty', '>= 0.16.2'

# Track exceptions
gem 'rollbar'

group :test do
  gem 'simplecov', :require => false
end

group :development do
  gem 'better_errors', '>= 2.5.0'
  gem 'memory_profiler'
  gem 'rack-mini-profiler', require: false
  gem 'solargraph', require: false
  gem 'web-console'
end

group :test, :development do
  # Simple Rails benchmarking
  gem 'benchmark-ips'

  gem 'capybara', '>= 3.14.0'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '>= 2.13'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 4.0.1'

  # Performance testing in RSpec
  gem 'rspec-benchmark'

  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', '>= 2.0.0pre', require: false
  gem 'shoulda-callback-matchers', '~> 1.1.4'
  gem 'shoulda-matchers', '>= 4.0.0'
  gem 'spring'
  gem 'spring-commands-rspec'
end

# Used by lib/

gem 'roo', "~> 2.8.1", require: false
gem 'rubyzip', require: false
gem 'sqlite3', require: false
gem 'whenever', '~> 1.0.0', require: false
