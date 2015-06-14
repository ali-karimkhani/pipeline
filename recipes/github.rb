# override fingerprint rsa
file "#{node['jenkins']['server']['home']}/.ssh/config" do
  content <<-EOD
   Host github.com
       StrictHostKeyChecking no
  EOD
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
end
