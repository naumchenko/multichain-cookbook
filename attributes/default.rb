# User for multichain
default['multichain']['user'] = 'multichain'
default['multichain']['group'] = 'multichain'
default['multichain']['home'] = '/opt/multichain'
default['multichain']['git_url'] = 'github.com/MultiChain/multichain.git'
default['multichain']['packages'] = %w(libdb4.8-dev libdb4.8++-dev software-properties-common libboost-all-dev build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils)
default['multichain']['version'] = '1.0'
default['multichain']['install_method'] = 'release'
default['multichain']['chain_name'] = 'chain1'
default['multichain']['port'] = '7343'
