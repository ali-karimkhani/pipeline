# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name "pipeline"

# Where to find external cookbooks:
default_source :community

# run_list: chef-client will run these recipes in the order specified.
run_list "pipeline::jenkins"

# Specify a custom source for a single cookbook:
# cookbook "development_cookbook", path: "../cookbooks/development_cookbook"

cookbook 'pipeline_test', path: 'test/fixtures/cookbooks/pipeline_test'

# - recipe[pipeline_test]
# - recipe[emacs]
# - recipe[pipeline::jenkins]
# - recipe[pipeline::chefdk]
# - recipe[chef-zero]
# - recipe[pipeline::knife]
# - recipe[pipeline::jobs]
