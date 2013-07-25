$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'mangopay/version'

Gem::Specification.new do |s|
  s.name        = 'mangopay'
  s.version     = MangoPay::VERSION
  s.summary     = "Ruby bindings for the version 2 of the MangoPay API"
  s.description = <<-EOF
  The mangopay Gem makes interacting with MangoPay Services much easier.
  For any questions regarding the use of MangoPay's Services feel free to contact us at http://www.mangopay.com/contact-us/
  You can find more documentation about MangoPay Services at http://www.mangopay.com/
  EOF
  s.authors     = ['Geoffroy Lorieux']
  s.email       = 'it-support@mangopay.com'
  s.homepage    = 'http://www.mangopay.com/'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency('multi_json', '~> 1.7.7')
  s.add_dependency('rest-client', '~> 1.6.7')

  s.add_development_dependency('rake', '~> 10.1.0')
  s.add_development_dependency('rspec', '~> 2.14.1')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
