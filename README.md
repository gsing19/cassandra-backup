Cassandra Backup/Restore
========================

* 0-backup-cassandra.sh - Copy Cassandra raw direrectory with it's files into desctination using rsync
* 1-downgrade-dse.sh - Downgrade Cassandra to the source version
* 2-upgrade-system.sh - Update Cassandra yaml files and system tables
* 3-delete-peers.sh - Delete peers
