Cassandra Backup/Restore
========================

* 0-backup-cassandra.sh - copy Cassandra raw direrectory with it's files into desctination using rsync
* 1-downgrade-dse.sh - downgrade Cassandra to the source version
* 2-delete-peers.sh - delete peers
* 3-upgrade-system.sh - update Cassandra yaml files and system tables`
