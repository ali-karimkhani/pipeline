# set up chef-repo job per chef-repo
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
        require 'berkshelf'
        
        berksfile = Berkshelf::Berksfile.from_file("#{node['jenkins']['master']['home']}/jobs/#{repo['name']}/workspace/Berksfile")
        
        Chef::Log.info("running install on Berksfile...")
        
        begin
          berksfile.update
        rescue
          berksfile.install
        end
        
        berksfile.list.reject{|c| c.location == nil}.each do |cookbook|
          Chef::Log.info(cookbook.location.to_s)
          xml = File.join(Chef::Config[:file_cache_path], "#{cookbook.name}-config.xml")

          template xml do
            source "job-config.xml.erb"
             variables(
               :git_url => cookbook.location.uri,
               :build_command => '_cookbook_command.sh.erb'
             )
          end

          # Create a jenkins job (default action is `:create`)
          jenkins_job cookbook.name do
            config xml
          end
        end
      rescue Exception => e
        Chef::Log.error("Error reading Berksfile: #{e.message}")
      end
    end
  end
end


