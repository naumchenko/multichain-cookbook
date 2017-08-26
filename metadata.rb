name 'multichain'
maintainer 'Alex N'
maintainer_email 'alex@devloft.com'
license 'All Rights Reserved'
description 'Installs/Configures multichain'
long_description 'Installs/Configures multichain'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends "apt"
depends "git"
