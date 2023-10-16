# frozen_string_literal: true

module PackwerkMermaid
  class Configuration
    attr_accessor :mermaid_title, :mermaid_text_type, :mermaid_shape_style,
                  :packwerk_directory, :packwerk_package_name_mapping, :packwerk_package_name_callback

    def initialize
      @packwerk_directory = "."
      @packwerk_package_name_mapping = {}
      @mermaid_title = nil
      @mermaid_text_type = MermaidFlowchartBuilder::TEXT
      @mermaid_shape_style = MermaidFlowchartBuilder::RECTANGLE_ROUNDED
    end
  end
end
