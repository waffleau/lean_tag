require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'

require_relative 'lean_tag/engine' if defined?(Rails)

module LeanTag

  def self.setup
    @configuration ||= Configuration.new
    yield @configuration if block_given?
  end

  class Configuration

    attr_accessor :delimiter, :force_lowercase, :force_parameterize

    def initialize
      self.delimiter = ','
      self.force_lowercase = true
      self.remove_unused = true
    end

  end

end
