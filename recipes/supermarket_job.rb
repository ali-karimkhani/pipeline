if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  search(:chef_orgs, "*:*").each do |org|
    org['chef_repos'].each do |repo|

      xml = File.join(Chef::Config[:file_cache_path], "#{repo['name']}-config.xml")

      template xml do
        source "job-config.xml.erb"
         variables(
           :git_url => repo['url'],
           :build_command => '_knife_commands.sh.erb'
         )
      end

      # Create a jenkins job (default action is `:create`)
      jenkins_job repo['name'] do
        config xml
      end

      begin
        require 'chef-dk'
        require 'chef-dk/policyfile_compiler'

        # HERE = File.expand_path(File.dirname(__FILE__))

        HERE = "#{node['jenkins']['master']['home']}/jobs/#{repo['name']}/workspace"

        policyfile_path = File.join(HERE, "Policyfile.rb")
        policyfile_content = IO.read(policyfile_path)

        policy = ChefDK::PolicyfileCompiler.evaluate(policyfile_content, policyfile_path)

        policy.graph_solution
        policy.install

        lock_data = policy.lock.to_lock

        cookbooks = Hash[policy.graph_demands.map {|k,v| [k, v]}]

        cookbooks.keys.each do |name|

          url = policy.cookbook_location_spec_for(name).source_options[:git]

          xml = File.join(Chef::Config[:file_cache_path], "#{name}-config.xml")

          template xml do
            source "job-config.xml.erb"
             variables(
               :git_url => url,
               :build_command => '_cookbook_command.sh.erb'
             )
          end

          # Create a jenkins job (default action is `:create`)
          jenkins_job name do
            config xml
          end
        end
      rescue Exception => e
      Chef::Log.error("Error reading Policyfile: #{e.message}")
      end
    end
  end
end
