ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Rails falla al arrancar si DATABASE_URL existe pero está vacío (ej: durante assets:precompile en Render).
# Si está vacío, lo eliminamos para que Rails use la config de database.yml sin crashear.
ENV.delete("DATABASE_URL") if ENV["DATABASE_URL"].to_s.strip.empty?

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
