module ChefZeroCookbook
  module Helpers
    extend self

    # @return [Chef::Node]
    attr_reader :node

    # Generate the command string given the context of the node
    #
    # @param [Chef::Node] node
    #
    # @return [String]
    def command(node)
      @node = node

      cmd = "#{bin_path}/chef-zero"
      cmd << " --host #{app['host']}"

      if app['listen'].to_i == 0
        cmd << " --socket #{app['listen']}"
      else
        cmd << " --port #{app['listen']}"
      end

      cmd << " --generate-real-keys" if app['generate_real_keys']
      cmd << " --daemon"

      cmd
    end

    private
      def bin_path
        File.expand_path(File.join(node['chef_packages']['chef']['chef_root'], '..', '..', '..', '..', '..', '..', '..', '..', 'bin'))
      end

      def app
        node['chef-zero']
      end
  end
end

module Pipeline
  module Helpers
    Chef::Recipe.send :include, self

    def path_to_config_for(name)
      file_cache_path = Chef::Config[:file_cache_path]
      file_name = "#{name}-config.xml"

      ::File.join file_cache_path, file_name
    end

    def each_chef_org(&block)
      if Chef::Config[:solo]
        Chef::Log.warn 'This recipe uses search;' \
                         'Chef solo does not support search'
      else
        search(:chef_orgs, '*:*').each(&block)
      end
    end

    def each_chef_repo(&block)
      each_chef_org do |org| org['chef-repos'].each(&block) end
    end
  end
end
