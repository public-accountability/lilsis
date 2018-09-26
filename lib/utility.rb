require 'csv'

# Various helper functions used by scripts and rake tasks.

module Utility
  def self.save_hash_array_to_csv(file_path, data, mode: 'wb')
    CSV.open(file_path, mode) do |csv|
      csv << data.first.keys
      data.each { |hash| csv << hash.values }
    end
  end

  def self.execute_sql_file(path)
    db = Rails.configuration.database_configuration.fetch(Rails.env)
    cmd = "mysql -u #{db['username']} -p#{db['password']} -h #{db['host']} #{db['database']} < #{path}"
    output = `#{cmd}`
    if $?.exitstatus != 0
      ColorPrinter.print_red output
      raise SQLFileError, output
    end
  end

  class SQLFileError < StandardError; end
end
