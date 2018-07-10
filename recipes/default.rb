#
# Cookbook Name:: cms_sq_sap_hana_rr_cluster_monitoring
# Recipe:: default
#
# Copyright 2018 IBM Corporation, All Rights Reserved

# TODO: write the cookbook
config_file = '/etc/zabbix/zabbix.conf.d/pacemaker.conf'
['resource_script.sh', 'log_script.sh'].each do |conf_file|
  cookbook_file "/var/lib/zabbix/#{conf_file}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    only_if { node['cluster_readiness']['HAcluster'] == 'true' }
  end
end
template config_file do
  source 'pacemaker.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  only_if { node['cluster_readiness']['HAcluster'] == 'true' }
  notifies :restart, 'service[zabbix-agent]', :delayed
end
[config_file, '/var/lib/zabbix/resource_script.sh', '/var/lib/zabbix/log_script.sh'].each do |conf_file|
  file conf_file do
    action :delete
    only_if { node['cluster_readiness']['HAcluster'] == 'false' }
    notifies :restart, 'service[zabbix-agent]', :delayed
  end
end
