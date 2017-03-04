source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.1"
gem "puma", "~> 3.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "aws-sdk", "~> 2"
gem "sidekiq"
gem "httparty"

gem "babel-transpiler"
gem 'sprockets', github: 'rails/sprockets', branch: 'master'

group :production do
  gem "postgresql"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "dotenv-rails"
end

group :development do
  gem "sqlite3"
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "progressbar"
  gem "rubocop-github"
end

group :test do
  gem "mocha"
  gem "factory_girl_rails"
  gem "vcr"
  gem "webmock"
  gem "minitest-vcr"
end
