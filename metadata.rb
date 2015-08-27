name 'pipeline'
maintainer 'Stephen Lauck'
maintainer_email 'lauck@getchef.com'
license 'All rights reserved'
description 'Installs/Configures a Jenkins based chef delivery pipeline'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.3.2'

%w( apt yum git java jenkins emacs delivery_build ).each do |cb|
  depends cb
end
