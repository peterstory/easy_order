# Copied from http://stackoverflow.com/questions/1196172/delete-everything-from-all-tables-in-activerecord
# Truncates all tables, making it easier to re-seed them
namespace :db do
  desc "Truncate all tables"
  task :truncate => :environment do
    conn = ActiveRecord::Base.connection
    tables = conn.execute("show tables").map { |r| r[0] }
    tables.delete "schema_migrations"
    tables.each { |t| conn.execute("TRUNCATE #{t}") }
  end
end