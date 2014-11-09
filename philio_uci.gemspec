Gem::Specification.new do |spec|
  spec.name = %q{philio_uci}
  spec.version = "0.0.3"
  spec.date = %q{2013-09-05}
  spec.summary = %q{gem for universal chess interface}

  spec.authors       = ["Padawan"]
  spec.email         = ["st.zawadzki@gmail.com"]

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", ">= 1.2"
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "redcarpet", ">= 2.2"
  spec.add_development_dependency "yard", ">= 0.8.5.2"

end
