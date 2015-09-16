#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "build-essential" do
  action :install
end

user node[:redis][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:redis][:dir] do
  owner "root"
  mode "0755"
  action :create
end

directory node[:redis][:data_dir] do
  owner "redis"
  mode "0755"
  action :create
end

directory node[:redis][:log_dir] do
  mode 0755
  owner node[:redis][:user]
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/redis-2.6.10.tar.gz" do
  source "http://redis.googlecode.com/files/redis-2.6.10.tar.gz"
  action :create_if_missing
end

bash "compile_redis_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf redis-2.6.10.tar.gz
    cd redis-2.6.10
    make && make install
  EOH
  creates "/usr/local/bin/redis-server"
end

service "redis" do
  provider Chef::Provider::Service::Upstart
  subscribes :restart, resources(:bash => "compile_redis_source")
  supports :restart => true, :start => true, :stop => true, :status => true
end

template "#{node[:redis][:dir]}/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis")
end

template "/etc/init/redis.conf" do
  source "redis.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis")
end

service "redis" do
  action [:enable, :restart, :start]
end