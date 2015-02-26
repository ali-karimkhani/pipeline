# set up chef-repo job per chef-repo
chef_repos.each do |repo|
  create_jenkins_job repo['name'], repo['url'], '_knife_commands.sh.erb'

  cookbooks_in_berksfile_of_repo(repo['name']).each do |cookbook|
    Chef::Log.info cookbook.location.to_s
    create_jenkins_job cookbook.name, cookbook.location.uri,
                       '_cookbook_command.sh.erb'
  end
end
