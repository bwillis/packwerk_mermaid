# frozen_string_literal: true

require_relative "lib/packwerk_mermaid/version"

Gem::Specification.new do |spec|
  spec.name          = "packwerk_mermaid"
  spec.version       = PackwerkMermaid::Version::VERSION
  spec.authors       = ["Ben Willis"]
  spec.email         = ["benjamin.willis@gmail.com"]

  spec.summary       = "Generate Mermaid diagrams for packwerk projects"
  spec.description   = "Generate Mermaid diagrams for packwerk projects"
  spec.homepage      = "https://github.com/bwillis/packwerk_mermaid"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bwillis/packwerk_mermaid"
  spec.metadata["changelog_uri"] = "https://github.com/bwillis/packwerk_mermaid/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "packwerk"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
