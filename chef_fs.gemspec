$:.unshift(File.dirname(__FILE__) + '/lib')
require 'chef_fs/version'

Gem::Specification.new do |s|
  s.name = "chef_fs"
  s.version = ChefFS::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.summary = "A library that treats the Chef server as if it were a filesystem"
  s.description = s.summary
  s.author = "John Keiser"
  s.email = "jkeiser@opscode.com"
  s.homepage = "http://www.opscode.com"

  # We need a more recent version of mixlib-cli in order to support --no- options.
  # ... but, we can live with those options not working, if it means the plugin
  # can be included with apps that have restrictive Gemfile.locks.
  # s.add_dependency "mixlib-cli", ">= 1.2.2"
  
  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,spec}/**/*")
end

