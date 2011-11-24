# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'hocus_pocus/version'

Gem::Specification.new do |s|
  s.name        = 'hocus_pocus'
  s.version     = HocusPocus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Akira Matsuda']
  s.email       = ['ronnie@dio.jp']
  s.homepage    = 'https://github.com/amatsuda/hocus_pocus'
  s.summary     = 'A magical Engine that casts a spell on your Rails 3.1 app'
  s.description = 'A magical Engine that casts a spell on your Rails 3.1 app'

  s.rubyforge_project = 'hocus_pocus'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib', 'engines/generator/lib', 'engines/editor/lib', 'engines/recorder/lib', 'engines/command_line/lib']

  s.extra_rdoc_files = ['README.rdoc']
  s.licenses = ['MIT']

  s.add_runtime_dependency 'rails', ['>= 3.0']
  s.add_runtime_dependency 'nested_scaffold', ['>= 0.1.0']
  s.add_development_dependency 'rack', ['1.3.3']
  s.add_development_dependency 'rake', ['0.8.7']
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'sqlite3'
end
