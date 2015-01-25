# set up chef-repo job per chef-repo
each_chef_repo do |repo|
  xml = path_to_config_for repo['name']

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
      xml = path_to_config_for cookbook.name

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
