# frozen_string_literal: true

require 'active_record'
require 'active_support'
require 'csv'
require 'fileutils'
require 'open-uri'
require 'open3'
require 'optparse'
require 'parallel'
require 'uri'
require 'zeitwerk'
require 'zip'

require_relative '../app/utility/name_parser'
require_relative '../app/utility/org_name'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'fec' => 'FEC'
loader.inflector.inflect 'pac' => 'PAC'
loader.collapse("#{__dir__}/fec/models")
loader.setup

module FEC
  mattr_accessor :configuration do
    default_root = if defined?(Rails)
                     Rails.root
                   else
                     Dir.pwd
                   end
    {
      data_directory: File.join(default_root, 'data/fec'),
      logfile: File.join(default_root, 'log/fec.log'),
      database: File.join(default_root, 'data/fec.db'),
      recheck: false,
      years: 2016..2020,
      tables: nil,
      parallel: true
    }
  end

  mattr_reader :logger do
    Logger.new configuration[:logfile], level: Logger::DEBUG
  end

  mattr_reader :tables do
    YAML.load_file(File.join(__dir__, 'fec/tables.yml')).map do |table|
      FEC::Table.new(**table.symbolize_keys).freeze
    end.freeze
  end

  # Two configuration values affect this:
  #  years  - range of years to cover, ie 2010..2016
  #  tables - if set, acts as a filter
  # yields a block for each table+year combination
  def self.loop_tables
    configuration.fetch(:years).each do |year|
      # The FEC bulk zip files are released in two-year cycles.
      next unless (year % 2).zero?

      tables.map(&:dup).each do |table|
        next if FEC.configuration[:tables] && !FEC.configuration[:tables].include?(table.name)

        table.year = year
        table.freeze
        yield table
      end
    end
  end

  def self.tables_with_years
    @tables_with_years ||= [].tap do |arr|
      loop_tables { |table| arr << table }
    end.freeze
  end

  def self.default_year
    2020
  end
end
