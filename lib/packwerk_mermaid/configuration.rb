# frozen_string_literal: true

module PackwerkMermaid
  class Configuration
    attr_accessor :packwerk_directory,
      :packwerk_package_name_mapping,
      :packwerk_loader,
      :packwerk_package_name_callback,
      :packwerk_packages_hidden,
      :mermaid_title,
      :mermaid_text_type,
      :mermaid_shape_style

    def initialize
      @packwerk_directory = "."
      @packwerk_package_name_mapping = {}
      @packwerk_loader = Proc.new { |dir| Packwerk::PackageSet.load_all_from(dir) }
      @packwerk_packages_hidden = []
      @mermaid_title = nil
      @mermaid_text_type = MermaidFlowchartBuilder::TEXT
      @mermaid_shape_style = MermaidFlowchartBuilder::RECTANGLE_ROUNDED
    end
  end
end
