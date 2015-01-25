module Pipeline
  module Helpers
    Chef::Recipe.send :include, self

    # Enumerate each organization in the Chef Server to the given block unless
    # executing Chef in solo mode
    #
    # @param [Proc] block
    def each_chef_org(&block)
      if Chef::Config[:solo]
        Chef::Log.warn 'This recipe uses search;' \
                         'Chef solo does not support search'
      else
        search(:chef_orgs, '*:*').each(&block)
      end
    end

    # Enumerate each cookbook in the Berksfile of the named Chef repo to the
    # given block
    #
    # @param [String] name
    # @param [Proc] block
    def each_cookbook_in_berksfile_of_repo(name, &block)
      require 'berkshelf'
      berksfile_from_repo(name).list.each do |cookbook|
        block.call cookbook unless cookbook.location.nil?
      end
    rescue LoadError
      Chef::Log.warn 'Berkshelf not available'
    end

    # Enumerate each repo of each organization in the Chef Server to the given
    # block
    #
    # @param [proc] block
    def each_chef_repo(&block)
      each_chef_org do |org| org['chef_repos'].each(&block) end
    end

    # Declare Chef resources for a job to be managed in Jenkins
    #
    # @param [String] name
    # @param [String] git_url
    # @param [String] build_command
    def create_jenkins_job(name, git_url, build_command)
      config_path = path_to_config name

      template config_path do
        source 'job-config.xml.erb'
        variables git_url: git_url, build_command: build_command
      end

      jenkins_job name do
        config config_path
      end
    end

    private

    def berksfile_from_repo(name)
      berksfile_path = path_to_berksfile_of_repo name

      Berkshelf::Berksfile.from_file(berksfile_path).tap do |berksfile|
        install_berksfile berskfile
      end
    end

    def install_berksfile(berksfile)
      Chef::Log.info 'Installing contents of Berksfile...'
      berskfile.lockfile.present? ? berksfile.update : berksfile.install
    end

    def path_to_berksfile_of_repo(name)
      "#{node['jenkins']['master']['home']}/jobs/#{name}/workspace" \
        '/Berksfile'
    end

    def path_to_config(name)
      file_cache_path = Chef::Config[:file_cache_path]
      file_name = "#{name}-config.xml"

      ::File.join file_cache_path, file_name
    end
  end
end
