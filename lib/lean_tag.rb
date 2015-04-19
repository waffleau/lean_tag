require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'

require_relative 'lean_tag/engine' if defined?(Rails)

module LeanTag

  def self.config
    @configuration ||= Configuration.new
  end

  def self.setup
    self.config
    yield self.config if block_given?
  end


  class Configuration

    attr_accessor :delimiter, :force_lowercase, :remove_unused

    def initialize
      self.delimiter = ','
      self.force_lowercase = true
      self.remove_unused = true
    end

  end

end
