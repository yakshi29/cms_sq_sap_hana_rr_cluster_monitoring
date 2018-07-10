is_cluster = attribute('HAcluster', default: 'false', description: 'Running on cluster')
if is_cluster == 'true'
  describe file('/etc/zabbix/zabbix.conf.d/pacemaker.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 0644 }
  end
  describe file('/var/lib/zabbix/resource_script.sh') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 0755 }
  end
  describe file('/var/lib/zabbix/log_script.sh') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 0755 }
  end
else
  describe file('/etc/zabbix/zabbix.conf.d/pacemaker.conf') do
    it { should_not exist }
  end
  describe file('/var/lib/zabbix/resource_script.sh') do
    it { should_not exist }
  end
  describe file('/var/lib/zabbix/log_script.sh') do
    it { should_not exist }
  end
end
