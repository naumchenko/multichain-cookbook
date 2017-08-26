#
# Cookbook Name:: multichain
# Recipe:: user
#
# Copyright (C) 2017 Alex Naumchenko
#
# All rights reserved - Do Not Redistribute
#

group node['multichain']['group'] do
  append true
end

user node['multichain']['user'] do
  gid node['multichain']['group']
  shell '/bin/bash'
  home node['multichain']['home']
  system true
  action :create
end

directory node['multichain']['home'] do
  action :create
  owner node['multichain']['user']
  group node['multichain']['group']
  recursive true
end
