#
# Copyright 2015-2017, Noah Kantrowitz
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
  describe 'default case' do
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
    it { is_expected.to sync_poise_git('/opt/ruby_build/install/master') }
    # with no special options passed in, we set --disable-install-doc by default
    it { is_expected.to run_execute('ruby-build install').with(environment: {'RUBY_CONFIGURE_OPTS' => '--disable-install-doc'}) }
    it { is_expected.to run_execute('ruby-build install').with(command: %w{/opt/ruby_build/install/master/bin/ruby-build 2.2.2 /opt/ruby_build/builds/2}) }
    it { is_expected.to create_file('/opt/ruby_build/builds/2/VERSION').with(content: '2.2.2') }
  end

  describe 'with extra environment variables' do
    step_into(:ruby_runtime)
    recipe do
      ruby_runtime '2' do
        provider :ruby_build
        options environment_variables: {
          'CONFIGURE_OPTS' => '--prefix=/usr/local',
          'RUBY_CONFIGURE_OPTS' => '--with-newlib'}
      end
    end
    before do
      allow_any_instance_of(described_class).to receive(:include_recipe)
      allow_any_instance_of(described_class).to receive(:ruby_definition).and_return('2.2.2')
    end

    # we use the CONFIGURE_OPTS that was passed in, but we concatenate the given
    # RUBY_CONFIGURE_OPTS with the default --disable-install-doc
    it { is_expected.to run_execute('ruby-build install').with(environment: {
      'CONFIGURE_OPTS' => '--prefix=/usr/local',
      'RUBY_CONFIGURE_OPTS' => '--with-newlib --disable-install-doc'}) }
  end
end
