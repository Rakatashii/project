source 'https://rubygems.org'

gem 'rails',                      '5.1.5'
gem 'bootstrap-sass',             '3.3.7' 
gem 'puma',                       '3.9.1'
gem 'sass-rails',                 '5.0.6'
gem 'uglifier',                   '3.2.0'
gem 'coffee-rails',               '4.2.2'
gem 'jquery-rails',               '4.3.1'
gem 'turbolinks',                 '5.0.1'
gem 'jbuilder',                   '2.7.0'
gem 'bcrypt',                     '3.1.11' 
gem 'faker',                      '1.8.7'  
gem 'will_paginate',              '3.1.6'  
gem 'bootstrap-will_paginate',    '1.0.0'  
gem 'carrierwave',                '~> 1.2' #WATCH
gem 'mini_magick',                '4.8.0'  #WATCH

group :development, :test do
  gem 'sqlite3',                  '1.3.13'
  gem 'byebug',                   '9.0.6', platform: [:mri] #, :mingw, :x64_mingw]
  #gem "rspec-rails"
end

group :development do
  gem 'web-console',              '3.5.1'
  gem 'listen',                   '3.1.5'
  gem 'spring',                   '2.0.2'
  gem 'spring-watcher-listen',    '2.0.1'
  gem 'pry-rails',                '0.3.6' 
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg',                       '0.18.4'
  gem 'fog',                      '2.0.0'  #WATCH - bundler did not update gems in production due to initial --without production - what to do about this?
end
