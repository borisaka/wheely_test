require "wheely_test/version"
require 'mongoid'
require 'wheely_test/car'
require 'redis'
# require 'ac'

module WheelyTest
  Mongoid.load!(File.join(File.dirname(__dir__), 'config', 'mongoid.yml'), :development)

  def self.cache
    @cache ||= Redis.new
  end

  def self.logger
    @logger ||= make_logger
  end

  def self.make_logger
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger
  end

  private_class_method :make_logger
end
