#!/bin/bash
#----------------------------------------------------------------------------------------#
sed -i 's/phi_convict_threshold/#phi_convict_threshold/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/TestBkp Cluster/J4U Prod Cluster/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/bkpanly/prwestaly/'  /etc/dse/cassandra/cassandra-rackdc.properties
sed -i 's/FD0/FD1/'  /etc/dse/cassandra/cassandra-rackdc.properties
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"
#----------------------------------------------------------------------------------------#
cqlsh -e "UPDATE system.local set cluster_name = 'J4U Prod Cluster' WHERE key ='local';"
cqlsh -e "UPDATE system.local set data_center='bkpanly' WHERE key ='local';"
cqlsh -e "UPDATE system.local set rack = 'FD0' WHERE key ='local';"
#----------------------------------------------------------------------------------------#
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"
#----------------------------------------------------------------------------------------#
nodetool flush
#----------------------------------------------------------------------------------------#
sed -i 's/J4U Prod Cluster/TestBkp Cluster/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/prwestaly/bkpanly/'  /etc/dse/cassandra/cassandra-rackdc.properties
sed -i 's/FD1/FD0/'  /etc/dse/cassandra/cassandra-rackdc.properties
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"
#----------------------------------------------------------------------------------------#
service dse restart
clear
tail -20f /var/log/cassandra/output.log
#----------------------------------------------------------------------------------------#
