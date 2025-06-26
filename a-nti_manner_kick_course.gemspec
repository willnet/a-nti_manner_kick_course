require_relative "lib/a/nti_manner_kick_course/version"

Gem::Specification.new do |spec|
  spec.name        = "a-nti_manner_kick_course"
  spec.version     = A::NtiMannerKickCourse::VERSION
  spec.authors     = [ "Shinichi Maeshima" ]
  spec.email       = [ "netwillnet@gmail.com" ]
  spec.homepage    = "https://github.com/willnet/a-nti_manner_kick_course"
  spec.summary     = "This library detects code or gems that violate lazy loading conventions during Rails initialization."
  spec.description = "This library detects code or gems that violate lazy loading conventions during Rails initialization."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/willnet/a-nti_manner_kick_course"
  spec.metadata["changelog_uri"] = "https://github.com/willnet/a-nti_manner_kick_course/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "railties", ">= 7.0.0"
  spec.add_dependency "activesupport", ">= 7.0.0"
end
