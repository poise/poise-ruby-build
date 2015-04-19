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

require 'poise_ruby/ruby_providers/base'


module PoiseRuby
  module RubyBuild
    class Provider < PoiseRuby::RubyProviders::Base
      provides(:ruby_build)

      def self.default_inversion_options(node, new_resource)
        super.merge({
          install_doc: false,
          install_repo: 'https://github.com/sstephenson/ruby-build.git',
          install_rev: 'master',
          prefix: '/opt/ruby_build',
        })
      end

      def action_install
        unless ::File.exists?(ruby_binary)
          converge_by("Installing Ruby #{options['version']} via ruby_build") do
            notifying_block do
              create_prefix_directory
              create_install_directory
              create_builds_directory
              install_ruby_build
              install_dependencies
              install_ruby
            end
          end
        end
      end

      def action_uninstall
        notifying_block do
          remove_ruby
        end
      end

      def ruby_binary
        ::File.join(options['prefix'], 'builds', options['version'], 'bin', 'ruby')
      end

      private

      def create_prefix_directory
        directory options['prefix'] do
          owner 'root'
          group 'root'
          mode '755'
        end
      end

      def create_install_directory
        directory ::File.join(options['prefix'], 'install') do
          owner 'root'
          group 'root'
          mode '755'
        end
      end

      def create_builds_directory
        directory ::File.join(options['prefix'], 'builds') do
          owner 'root'
          group 'root'
          mode '755'
        end
      end

      def install_ruby_build
        include_recipe 'git' unless options['no_dependencies']
        git ::File.join(options['prefix'], 'install', options['install_rev']) do
          repository options['install_repo']
          revision options['install_rev']
          user 'root'
        end
      end

      def install_dependencies
        return if options['no_dependencies']
        include_recipe 'build-essential'
        unless options['version'].start_with?('jruby')
          pkgs = node.value_for_platform_family(
            debian: %w{libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev libxml2-dev libxslt1-dev},
            rhel: %w{tar readline-devel zlib-devel libffi-devel openssl-devel libxml2-devel libxslt-devel},
            suse: %w{zlib-devel libffi-devel sqlite3-devel libxml2-devel libxslt-devel},
          )
          package pkgs if pkgs
        end
      end

      def install_ruby
        # Figure out the argument to disable docs
        disable_docs = if options['install_doc']
          nil
        elsif options['version'].start_with?('rbx')
          nil # Doesn't support?
        elsif options['version'].start_with?('ree')
          '--no-dev-docs'
        else
          '--disable-install-doc'
        end

        execute 'ruby-build install' do
          command [::File.join(options['prefix'], 'install', options['install_rev'], 'bin', 'ruby-build'), options['version'], ::File.join(options['prefix'], 'builds', options['version'])]
          user 'root'
          environment 'RUBY_CONFIGURE_OPTS' => disable_docs if disable_docs
        end
      end

      def remove_ruby
        directory ::File.join(options['prefix'], 'builds', options['version']) do
          action :delete
        end
      end
    end
  end
end
