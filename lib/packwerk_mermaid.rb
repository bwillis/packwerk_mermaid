# frozen_string_literal: true

require_relative "packwerk_mermaid/version"
require_relative "packwerk_mermaid/configuration"

module PackwerkMermaid
  class Error < StandardError; end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
