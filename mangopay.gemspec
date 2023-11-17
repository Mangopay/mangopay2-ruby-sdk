$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'mangopay/version'

Gem::Specification.new do |s|
  s.name        = 'mangopay'
  s.version     = MangoPay::VERSION
  s.summary     = "Ruby bindings for the version 2 of the MANGOPAY API"
  s.description = <<-EOF
  The mangopay Gem makes interacting with MANGOPAY Services much easier.
  For any questions regarding the use of MANGOPAY's Services feel free to contact us at http://www.mangopay.com/get-started-2/
  You can find more documentation about MANGOPAY Services at http://docs.mangopay.com/
  EOF
  s.authors     = ['Geoffroy Lorieux', 'Sergiusz Woznicki']
  s.email       = 'support@mangopay.com'
  s.homepage    = 'http://docs.mangopay.com/'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency('multi_json', '>= 1.7.7')
  s.add_dependency('activesupport', '>= 5.0')

  s.add_development_dependency('rake', '>= 10.1.0')
  s.add_development_dependency('rspec', '>= 3.0.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
