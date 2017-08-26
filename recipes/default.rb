#
# Cookbook:: multichain
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'multichain::user'

if node['multichain']['install_method'] == 'release'
  bash "Install Multichain" do
    not_if "/usr/local/bin/multichain --version | grep -q '#{node['multichain']['version']}'"
    user "root"
    cwd "/tmp"
    code <<-EOH
      wget https://www.multichain.com/download/multichain-#{node['multichain']['version']}-release.tar.gz -O /tmp/multichain-#{node['multichain']['version']}-release.tar.gz
      tar -zxf multichain-#{node['multichain']['version']}-release.tar.gz
      (mv /tmp/multichain-#{node['multichain']['version']}-release/multichain* /usr/local/bin)
    EOH
  end
else
  include_recipe 'apt'
  git_client 'default' do
    action :install
  end
  apt_repository 'bitcoin' do
    uri          'ppa:bitcoin/bitcoin'
  end
  node['multichain']['packages'].each do |i|
    package i do
      action :install
    end
  end
  bash "compile_from_source" do
    not_if "/usr/local/bin/multichain --version | grep -q '#{node['multichain']['version']}'"
    user node['multichain']['user']
    cwd "/tmp"
    code <<-EOH
      git clone git@github.com:MultiChain/multichain.git
      (cd multichain && ./autogen.sh && ./configure && make)
      (mv multichaind multichain-cli multichain-util /usr/local/bin)
    EOH
  end
end

if node['multichain']['role'] == 'server'
  execute 'Create chain' do
    user node['multichain']['user']
    cwd node['multichain']['home']
    command "multichain-util create #{node['multichain']['chain_name']} -default-network-port=#{node['multichain']['port']} -anyone-can-connect=true"
    action :run
    environment ({'HOME' => '/opt/multichain'})
    not_if { File.exist?("#{node['multichain']['home']}/.multichain/#{node['multichain']['chain_name']}/params.dat") }
  end
  execute 'Run multichaind daemon' do
    user node['multichain']['user']
    cwd node['multichain']['home']
    command "multichaind #{node['multichain']['chain_name']} -daemon"
    action :run
    environment ({'HOME' => '/opt/multichain'})
    not_if "ps aux | pgrep multichaind"
  end
else
  execute 'Join node to server' do
    user node['multichain']['user']
    cwd node['multichain']['home']
    command "multichaind #{node['multichain']['chain_name']}@#{node['multichain']['server_ip']}:7343 -daemon"
    action :run
    environment ({'HOME' => '/opt/multichain'})
    not_if "ps aux | pgrep multichaind"
  end
end
