packagecloud_repo 'chef/current' do
  type value_for_platform_family(debian: 'deb', rhel: 'rpm')
end

package 'delivery-cli' do
  action :upgrade
end