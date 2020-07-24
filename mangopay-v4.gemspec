$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'mangopay'

Gem::Specification.new do |spec|
  spec.name = 'mangopay-v4'
  spec.version = MangoPay::VERSION
  spec.summary = 'Ruby bindings for the version 2 of the MANGOPAY API'
  spec.description = <<-EOF
  The mangopay Gem makes interacting with MANGOPAY Services much easier.
  For any questions regarding the use of MANGOPAY's Services feel free to contact us at http://www.mangopay.com/get-started-2/
  You can find more documentation about MANGOPAY Services at http://docs.mangopay.com/
  EOF
  spec.authors = ['MangoTeam']
  spec.email = 'support@mangopay.com'
  spec.homepage = 'http://docs.mangopay.com/'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_dependency('multi_json', '>= 1.7.7')

  spec.add_development_dependency('rake', '>= 10.1.0')
  spec.add_development_dependency('rspec', '>= 3.0.0')

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- spec/*`.split("\n")
  spec.executables = `git ls-files -- bin/*`
                     .split("\n")
                     .map { |file| File.basename(file) }
  spec.require_paths = ['lib']
end
