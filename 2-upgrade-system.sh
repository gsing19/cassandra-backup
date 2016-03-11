#!/bin/bash
#----------------------------------------------------------------------------------------#
SOURCE_CLUSTER='J4U Prod Cluster'
SOURCE_DC='prwestaly'
SOURCE_RACK='FD1'
#----------------------------------------------------------------------------------------#
DESTINATION_CLUSTER='TestBkp Cluster'
DESTINATION_DC='bkpanly'
DESTINATION_RACK='FD0'


#----------------------------------------------------------------------------------------#
# Get Cassandra running with source cluster settings
#----------------------------------------------------------------------------------------#
sed -i 's/phi_convict_threshold/#phi_convict_threshold/' /etc/dse/cassandra/cassandra.yaml
#----------------------------------------------------------------------------------------#
sed -i 's/$DESTINATION_CLUSTER/$SOURCE_CLUSTER/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/$DESTINATION_DC/$SOURCE_DC/'  /etc/dse/cassandra/cassandra-rackdc.properties
sed -i 's/$DESTINATION_RACK/$SOURCE_RACK/'  /etc/dse/cassandra/cassandra-rackdc.properties
#----------------------------------------------------------------------------------------#
service dse restart
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
# Delete peers so Cassandra will not join the old cluster
#----------------------------------------------------------------------------------------#
./3-delete-peers.sh


#----------------------------------------------------------------------------------------#
# Upgrade System Tables
#----------------------------------------------------------------------------------------#
cqlsh -e "UPDATE system.local set cluster_name = '$DESTINATION_CLUSTER' WHERE key ='local';"
cqlsh -e "UPDATE system.local set data_center='$DESTINATION_DC' WHERE key ='local';"
cqlsh -e "UPDATE system.local set rack = '$DESTINATION_RACK' WHERE key ='local';"
#----------------------------------------------------------------------------------------#
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"

#----------------------------------------------------------------------------------------#
# Flush new system settings 
#----------------------------------------------------------------------------------------#
nodetool flush


#----------------------------------------------------------------------------------------#
# Update settings with new Cassandra settings
#----------------------------------------------------------------------------------------#
sed -i 's/$SOURCE_CLUSTER/$DESTINATION_CLUSTER/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/$SOURCE_DC/$DESTINATION_DC/'  /etc/dse/cassandra/cassandra-rackdc.properties
sed -i 's/$SOURCE_RACK/$DESTINATION_RACK'  /etc/dse/cassandra/cassandra-rackdc.properties
#----------------------------------------------------------------------------------------#
cqlsh -e "SELECT key, cluster_name, data_center, rack from system.local;"
#----------------------------------------------------------------------------------------#
# Restart the DSE to verify that DSE cluster can succesfully start
#----------------------------------------------------------------------------------------#
service dse restart
clear
tail -20f /var/log/cassandra/output.log
#----------------------------------------------------------------------------------------#
