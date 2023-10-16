# frozen_string_literal: true

require "packwerk"
require_relative "mermaid_flowchart_builder"
require_relative "../packwerk_mermaid"

module PackwerkMermaid
  class PackwerkFlowchart
    def initialize(configuration = PackwerkMermaid.configuration)
      @configuration = configuration
    end

    def generate
      package_set = Packwerk::PackageSet.load_all_from(@configuration.packwerk_directory)

      builder = MermaidFlowchartBuilder.new
      builder
        .set_title(@configuration.mermaid_title)
        .set_text_type(@configuration.mermaid_text_type)
        .set_shape_style(@configuration.mermaid_shape_style)

      @configuration.packwerk_package_name_mapping.each do |name, new_name|
        builder.set_node_display_name(name, new_name)
      end

      package_set.packages.each do |_path, package|
        package.dependencies.each do |dependency_name|
          builder.add_edge(
            rename_package(package.name),
            rename_package(dependency_name)
          )
        end
      end

      builder.build
    end

    def rename_package(name)
      return name unless @configuration.packwerk_package_name_callback.present?

      @configuration.packwerk_package_name_callback.call(name)
    end
  end
end
