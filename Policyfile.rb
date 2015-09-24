# A name that describes what the system you're building with Chef does.
name 'pipeline'

# Where to find external cookbooks:
default_source :community

# run_list: chef-client will run these recipes in the order specified.
run_list(
  'pipeline::jenkins',
  'delivery_build::default',
  'pipeline::supermarket_job'
)

# Specify a custom source for a single cookbook:
# cookbook "development_cookbook", path: "../cookbooks/development_cookbook"

cookbook 'pipeline_test', path: 'test/fixtures/cookbooks/pipeline_test'
cookbook 'delivery_build', git: 'https://github.com/chef-cookbooks/delivery_build.git'
cookbook 'pipeline', path: './'

# - recipe[pipeline_test]
# - recipe[emacs]
# - recipe[pipeline::jenkins]
# - recipe[pipeline::chefdk]
# - recipe[chef-zero]
# - recipe[pipeline::knife]
# - recipe[pipeline::jobs]
