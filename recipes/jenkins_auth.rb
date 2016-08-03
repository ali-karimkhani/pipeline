file "#{node['jenkins']['master']['home']}/jenkins.install.InstallUtil.lastExecVersion" do
  content <<-EOD
2.0
  EOD
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['user']
end

# add proxy for jenkins
template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'config.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(

  )
  notifies :execute, 'jenkins_command[safe-restart]', :immediately
end
