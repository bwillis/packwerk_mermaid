# frozen_string_literal: true

module PackwerkMermaid
  class MermaidFlowchartBuilder
    Node = Struct.new(:short_identifier, :identifier) do
      def display_name
        @display_name || identifier
      end

      attr_writer :display_name
    end

    DIRECTION = [
      TOP_DOWN = "TD",
      LEFT_TO_RIGHT = "LR"
    ].freeze

    NODE_SHAPE = [
      RECTANGLE = "rectangle",
      RECTANGLE_ROUNDED = "rectangle_rounded",
      STADIUM = "stadium",
      SUBROUTINE = "subroutine",
      CYLINDRICAL = "cylindrical",
      CIRCLE = "circle",
      CIRCLE_DOUBLE = "circle_double",
      ASYMMETRIC = "asymmetric",
      RHOMBUS = "rhombus",
      HEXAGON = "hexagon",
      PARALLELOGRAM_RIGHT = "parallelogram_right",
      PARALLELOGRAM_LEFT = "parallelogram_left",
      TRAPEZOID_DOWN = "trapezoid_down",
      TRAPEZOID_UP = "trapezoid_up"
    ].freeze

    TEXT_TYPE = [
      TEXT = "text",
      MARKDOWN = "markdown"
    ].freeze

    def initialize
      @edges = []
      @nodes = []
      @direction = TOP_DOWN
      @title = nil
      @text_type = TEXT
      @shape_style = RECTANGLE_ROUNDED
    end

    def set_title(title)
      @title = title

      self
    end

    def set_text_type(new_text_type)
      raise Error, "Invalid text type, expected one of #{TEXT_TYPE.join(", ")}" unless TEXT_TYPE.include?(new_text_type)

      @text_type = new_text_type

      self
    end

    def set_shape_style(new_shape_style)
      raise Error, "Invalid shape, expected one of #{NODE_SHAPE.join(", ")}" unless NODE_SHAPE.include?(new_shape_style)

      @shape_style = new_shape_style

      self
    end

    # https://mermaid.js.org/syntax/flowchart.html#direction
    def set_direction(new_direction)
      raise Error, "Invalid direction, expected one of: #{DIRECTION.join(",")}" unless DIRECTION.include? new_direction

      @direction = new_direction

      self
    end

    def add_edge(source, destination)
      @edges << [find_or_add_node(source), find_or_add_node(destination)]

      self
    end

    def set_node_display_name(identifier, new_name)
      node = find_or_add_node(identifier)
      node.display_name = new_name

      self
    end

    def build
      @name_registered = []
      mermaid_string = ""
      if @title
        mermaid_string += <<~TITLE
          ---
          title: #{@title}
          ---
        TITLE
      end
      mermaid_string += "flowchart #{@direction}"
      mermaid_string += "\n"
      @edges.each do |source, destination|
        mermaid_string += "    #{add_mermaid_node_reference(source)} --> #{add_mermaid_node_reference(destination)};"
        mermaid_string += "\n"
      end

      mermaid_string
    end

    private

    def add_node(identifier)
      raise Error, "node already exists with this identifier" if @nodes.any? { |node| node.identifier == identifier }

      Node.new(@nodes.length, identifier).tap do |node|
        @nodes << node
      end
    end

    def find_or_add_node(identifier)
      @nodes.find { |node| node.identifier == identifier } || add_node(identifier)
    end

    def add_mermaid_node_reference(node)
      if @name_registered.include? node.short_identifier
        node.short_identifier
      else
        @name_registered << node.short_identifier
        "#{node.short_identifier}#{mermaid_node_style(node.display_name)}"
      end
    end

    def mermaid_node_style(text, shape_style = @shape_style, text_type = @text_type)
      # https://mermaid.js.org/syntax/flowchart.html#markdown-formatting
      wrapped_text = case text_type
                     when TEXT
                       "\"#{text}\""
                     when MARKDOWN
                       "\"`#{text}`\""
                     else
                       raise Error, "unsupported, but we could support markdown probably"
                     end

      # https://mermaid.js.org/syntax/flowchart.html#node-shapes
      case shape_style
      when RECTANGLE
        "[#{wrapped_text}]"
      when RECTANGLE_ROUNDED
        "(#{wrapped_text})"
      when STADIUM
        "([#{wrapped_text}])"
      when SUBROUTINE
        "[[#{wrapped_text}]]"
      when CYLINDRICAL
        "[(#{wrapped_text})]"
      when CIRCLE
        "((#{wrapped_text}))"
      when CIRCLE_DOUBLE
        "(((#{wrapped_text})))"
      when ASYMMETRIC
        ">#{wrapped_text}]"
      when RHOMBUS
        "{#{wrapped_text}}"
      when HEXAGON
        "{{#{wrapped_text}}}"
      when PARALLELOGRAM_RIGHT
        "[/#{wrapped_text}/]"
      when PARALLELOGRAM_LEFT
        "[\\#{wrapped_text}\\]"
      when TRAPEZOID_DOWN
        "[\\#{wrapped_text}/]"
      when TRAPEZOID_UP
        "[/#{wrapped_text}\\]"
      else
        raise Error, "unsupported, but we could support other shapes"
      end
    end
  end
end
