chef_dk 'pipeline_chefdk' do
  version node['pipeline']['chefdk']['version']
  global_shell_init true
  action :install
end
