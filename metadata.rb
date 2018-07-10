name 'cms_sq_sap_hana_rr_cluster_monitoring'
maintainer 'Maintainer name here'
maintainer_email 'Your email here'
license 'Proprietary - All Rights Reserved'
description 'Installs/Configures cms_sq_sap_hana_rr_cluster_monitoring'
long_description 'Installs/Configures cms_sq_sap_hana_rr_cluster_monitoring'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.ibm.com/cms-infra-cookbooks/cms_sq_sap_hana_rr_cluster_monitoring/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.ibm.com/cms-infra-cookbooks/cms_sq_sap_hana_rr_cluster_monitoring'

supports 'redhat', '>= 6.5'

depends 'fms-zabbix', '~> 0.3.0'
