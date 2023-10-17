# frozen_string_literal: true

require "packwerk"
require_relative "mermaid_flowchart_builder"

module PackwerkMermaid
  class PackwerkFlowchart
    def initialize(configuration = PackwerkMermaid.configuration)
      @configuration = configuration
    end

    def generate
      package_set = @configuration.packwerk_loader.call(@configuration.packwerk_directory)

      builder = MermaidFlowchartBuilder.new
      builder
        .set_title(@configuration.mermaid_title)
        .set_text_type(@configuration.mermaid_text_type)
        .set_shape_style(@configuration.mermaid_shape_style)

      package_set.packages.each do |_path, package|
        next if @configuration.packwerk_packages_hidden.include? package.name

        package.dependencies.each do |dependency_name|
          next if @configuration.packwerk_packages_hidden.include? dependency_name

          builder.add_edge(
            rename_package(package.name),
            rename_package(dependency_name)
          )
        end
      end

      builder.build
    end

    def rename_package(name)
      return @configuration.packwerk_package_name_mapping[name] unless @configuration.packwerk_package_name_mapping[name].nil?
      return name if @configuration.packwerk_package_name_callback.nil?

      @configuration.packwerk_package_name_callback.call(name)
    end
  end
end
