# add proxy for jenkins
template "#{node['jenkins']['master']['home']}/proxy.xml" do
  source 'proxy.xml.erb'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0644
  variables(
    proxy: node['aw-pipeline']['proxy']['https'],
    port: node['aw-pipeline']['proxy']['port']
  )
  notifies :execute, 'jenkins_command[safe-restart]', :immediately
end
