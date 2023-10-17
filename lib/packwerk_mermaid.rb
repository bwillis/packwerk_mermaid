# frozen_string_literal: true

require_relative "packwerk_mermaid/version"
require_relative "packwerk_mermaid/configuration"
require_relative "packwerk_mermaid/packwerk_flowchart"

module PackwerkMermaid
  class Error < StandardError; end

  def self.configure
    Configuration.new.tap do |configuration|
      yield(configuration)
    end
  end
end
