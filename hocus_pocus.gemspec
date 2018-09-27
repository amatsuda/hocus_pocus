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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib', 'engines/generator/lib', 'engines/editor/lib', 'engines/recorder/lib', 'engines/command_line/lib']

  s.extra_rdoc_files = ['README.rdoc']
  s.licenses = ['MIT']

  s.add_runtime_dependency 'nested_scaffold', ['>= 0.1.0']
end
