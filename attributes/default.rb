default['pipeline']['jenkins']['plugins'] = %w{ scm-api git git-client github-api github chef-identity }

# use chef-zero url for default
default['pipeline']['chef_server']['url'] = "http://0.0.0.0:80"
default['pipeline']['chef_server']['node_name'] = "pipeline"

# use example chef-repo and poll master branch every minute by default
default['pipeline']['chef-repo']['url'] = "https://github.com/stephenlauck/pipeline-example-chef-repo.git"
default['pipeline']['chef-repo']['branch'] = "*/master"
default['pipeline']['chef-repo']['polling'] = "* * * * *"

# non-pipelined berks group for community cookbook install/upload
default['pipeline']['berkshelf']['external']['group'] = "community"

# set proxy for adding jenkins plugins
default['pipeline']['proxy']['https'] = "yourproxy.com"
default['pipeline']['proxy']['port'] = "8080"

# 
default['pipeline']['github']['server'] = "github.com"

default['java']['jdk_version'] = '7'

default['pipeline']['chefdk']['version'] = 'latest'

default['pipeline']['template']['cookbook'] = 'pipeline'
