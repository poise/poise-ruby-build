#
# Copyright 2015, Noah Kantrowitz
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

require 'spec_helper'

describe PoiseRuby::RubyBuild::Provider do
  let(:chefspec_options) { {log_level: :debug} }
  step_into(:ruby_runtime)
  recipe do
    ruby_runtime '2' do
      provider :ruby_build
    end
  end
  before do
    allow_any_instance_of(described_class).to receive(:include_recipe)
    allow_any_instance_of(described_class).to receive(:ruby_definition).and_return('2.2.2')
  end

  it { is_expected.to create_directory('/opt/ruby_build') }
  it { is_expected.to create_directory('/opt/ruby_build/install') }
  it { is_expected.to create_directory('/opt/ruby_build/builds') }
  it { is_expected.to sync_git('/opt/ruby_build/install/master') }
  it { is_expected.to run_execute('ruby-build install').with(command: %w{/opt/ruby_build/install/master/bin/ruby-build 2.2.2 /opt/ruby_build/builds/2}) }
  it { is_expected.to create_file('/opt/ruby_build/builds/2/VERSION').with(content: '2.2.2') }
end
