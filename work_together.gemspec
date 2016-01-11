# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'work_together/version'

Gem::Specification.new do |spec|
  spec.name          = "work_together"
  spec.version       = WorkTogether::VERSION
  spec.authors       = ["Sophie DeBenedetto"]
  spec.email         = ["sophie.debenedetto@gmail.com"]

  spec.summary       = %q{Automatically generate pairs and tables for you class from the command line.}
  spec.homepage      = "https://github.com/SophieDeBenedetto/work-together"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.bindir        = "exec"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables << 'work-together'
  spec.files         = ["lib/work_together/client.yml", "lib/work_together/learn_proxy.rb", "lib/work_together/pair_maker.rb", "lib/work_together/parser.rb", "lib/work_together/student.rb", "lib/work_together/table.rb", "lib/work_together/version.rb", "lib/work_together.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'mechanize'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'colorize'

end


