#
# Copyright 2015-2016, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poise_ruby/ruby_build/version'

Gem::Specification.new do |spec|
  spec.name = 'poise-ruby-build'
  spec.version = PoiseRuby::RubyBuild::VERSION
  spec.authors = ['Noah Kantrowitz']
  spec.email = %w{noah@coderanger.net}
  spec.description = "A Chef cookbook for managing Ruby installations using ruby-build."
  spec.summary = spec.description
  spec.homepage = 'https://github.com/poise/poise-ruby-build'
  spec.license = 'Apache 2.0'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'halite', '~> 1.0'
  spec.add_dependency 'poise', '~> 2.0'
  spec.add_dependency 'poise-ruby', '~> 2.1'

  spec.add_development_dependency 'berkshelf', '~> 4.0'
  spec.add_development_dependency 'poise-boiler', '~> 1.6'

  spec.metadata['halite_dependencies'] = 'git ~> 4.2, build-essential ~> 2.2'
end
