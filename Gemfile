source "https://rubygems.org"

ruby "3.2.9"

gem "rails", "~> 7.1.6"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Autenticación
gem "devise"

# Búsqueda full-text con pg_trgm
gem "pg_search"

# Background jobs
gem "sidekiq"

# Caché y Sidekiq backend
gem "redis"

# Paginación
gem "pagy"

# Importación de Excel
gem "roo", "~> 2.10"

# Generación de Excel (.xlsx) para plantillas descargables
gem "caxlsx_rails"

# Panel de administración interno
gem "activeadmin"
gem "dartsass-sprockets"
gem "ransack"

# Variables de entorno
gem "dotenv-rails"

# Procesamiento de imágenes para Active Storage (logos de farmacias)
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end
