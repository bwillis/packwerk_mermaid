# Packwerk Mermaid

This is a simple gem for a project using [packwerk](https://github.com/Shopify/packwerk) to generate a [Mermaid](https://mermaid.js.org/) diagram. When you generate the output, you can get a diagram that looks like this:

```mermaid
---
title: App Name
---
flowchart TD
    0("Nelson Hamill") --> 1("Msgr. Cynthia Dickens");
    0 --> 2("Adell Friesen MD");
    2 --> 3("Cortez Purdy");
    2 --> 4("Renaldo Collier");
    2 --> 5("Titus Schamberger");
    2 --> 6("Efren Kuhlman");
    2 --> 7("Osvaldo Legros Esq.");
    2 --> 8("Byron Hammes");
    6 --> 9("Carlo Nolan DDS");
    3 --> 9;
    1 --> 2;
    10("Mayola Kovacek") --> 2;
    10 --> 1;
    10 --> 5;
    10 --> 6;

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'packwerk_mermaid'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install packwerk_mermaid

## Usage

There is no CLI, but it's easy enough to write a Ruby script and run it like so:

```ruby
require "packwerk_mermaid"
require "packwerk_mermaid/packwerk_flowchart"

configuration = PackwerkMermaid.configure do |config|
  # The title that appears at the top of your diagram
  config.mermaid_title = 'Title of my Diagram'
  
  # Text or Markdown support
  config.mermaid_text_type = 'text'
  
  # What shape should the diagram use
  config.mermaid_shape_style = 'rectangle_rounded'
  
  # What directory is packwerk's root dir
  config.packwerk_directory = '.'
  
  # Simple static mapping for renaming packages, these happened
  # before the packwerk_package_name_callback runs
  config.packwerk_package_name_mapping = {
    '.' => 'root',
    'packs/cli' => 'CLI',
  }
  
  # Flexible way to rename packages
  config.packwerk_package_name_callback = lambda { |name| name.gsub('packs/', '') }

  # Simple static mapping of packages to hide
  config.packwerk_packages_hidden = [
    'packs/utilities',
    'packs/legacy_service',
  ]
  
  # Flexible way to show/hide packages
  config.packwerk_package_name_callback = lambda { |node_name, parent_node_name| should_show?(node_name) }
end

PackwerkMermaid::PackwerkFlowchart.new(configuration).generate
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwillis/packwerk_mermaid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bwillis/packwerk_mermaid/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PackwerkMermaid project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bwillis/packwerk_mermaid/blob/master/CODE_OF_CONDUCT.md).
