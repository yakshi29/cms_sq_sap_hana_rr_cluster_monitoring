#
## Cookbook:: cms_sq_sap_hana_rr_cluster_monitoring
# Spec:: default
#
# Copyright 2018 IBM Corporation, All Rights Reserved

require 'spec_helper'

describe 'cms_sq_sap_hana_rr_cluster_monitoring::default' do
  context 'SUSE Linux Enterprise Server 12 (x86_64)' do
    context 'When the node is HAcluster' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(platform: 'suse', version: '12.2') do |node|
          node.normal['cluster_readiness']['HAcluster'] = 'true'
          node.normal['authentication']['dc_hostname'] = 'dal09ammadc001.example.com'
          node.normal['authentication']['ads_org_unit'] = 'Infrastructure Servers'
          node.normal['chef_client']['config']['chef_server_url'] = 'https://chef.example.com/organizations/test'
          node.normal['authentication']['default_realm'] = 'IMZCLOUD.IBMAMMSAP.LOCAL'
        end
        runner.converge('fms-zabbix::default', described_recipe)
      end
      it 'creates the resource script file' do
        expect(chef_run).to create_cookbook_file('/var/lib/zabbix/resource_script.sh').with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
      end
      it 'creates the log script file' do
        expect(chef_run).to create_cookbook_file('/var/lib/zabbix/log_script.sh').with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
      end
      it 'creates the pacemaker template ' do
        expect(chef_run).to create_template('/etc/zabbix/zabbix.conf.d/pacemaker.conf').with(
          source: 'pacemaker.conf.erb',
          owner: 'root',
          group: 'root',
          mode: '0644'
        )
      end
    end
    context 'When the node is not HAcluster' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(platform: 'suse', version: '12.2') do |node|
          node.normal['cluster_readiness']['HAcluster'] = 'false'
          node.normal['authentication']['dc_hostname'] = 'dal09ammadc001.example.com'
          node.normal['authentication']['ads_org_unit'] = 'Infrastructure Servers'
          node.normal['chef_client']['config']['chef_server_url'] = 'https://chef.example.com/organizations/test'
          node.normal['authentication']['default_realm'] = 'IMZCLOUD.IBMAMMSAP.LOCAL'
        end
        runner.converge('fms-zabbix::default', described_recipe)
      end
      it 'deletes the conf file' do
        expect(chef_run).to delete_file('/etc/zabbix/zabbix.conf.d/pacemaker.conf')
      end
      it 'deletes the resource script file' do
        expect(chef_run).to delete_file('/var/lib/zabbix/resource_script.sh')
      end
      it 'deletes the log script file' do
        expect(chef_run).to delete_file('/var/lib/zabbix/log_script.sh')
      end
    end
  end
end
