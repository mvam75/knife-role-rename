# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'knife-role-replace/version'

Gem::Specification.new do |g|
  g.authors             = ["mvam75"]
  g.email               = ["foo@example.org"]
  g.description         = %q{Replaces roles on a node when given search criteria}
  g.summary             = %q{Replaces roles on a node when given search criteria. Use 'knife role replace' To search and replace roles on a node.}
  g.homepage            = 'https://github.com/mvam75/knife-role-replace'

  g.files               = `git ls-files`.split($\)
  g.executables         = g.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  g.name                = "knife-role-replace"
  g.require_paths       = ["lib"]
  g.version             = Knife::TP::VERSION
end
