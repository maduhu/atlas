#!/usr/bin/env bash
############################################################################
# This shell file is to imulate a sqoop handler process.
# Version- 1.1
# Date - August 22, 2015
#
# Replace the ${mysql_host} with the host of the mysql server
# Also check the mysql users. Replace it with the correct mysql users
###############################################################################

mysql_host=${mysql_host:-localhost}
hdp_host=${hdp_host:-localhost}

## Load the tables
sqoop import --connect jdbc:mysql://${mysql_host}/test --username trucker1 --password trucker --table DRIVERS -m 1 --target-dir demo$1 --hive-import --hive-table DRIVERS$1

sqoop import --connect jdbc:mysql://${mysql_host}/test --username trucker1 --password trucker --table TIMESHEET -m 1 --target-dir demo$1 --hive-import --hive-table TIMESHEET$1

## Alternatively load the tables to ORC
#sqoop import --verbose --connect jdbc:mysql://${mysql_host}/test \
  #--username trucker1 --password trucker --table DRIVERS -m 1 \
  #--hcatalog-table DRIVERS --hcatalog-storage-stanza "stored as orc" -m 1 --create-hcatalog-table

#sqoop import --verbose --connect jdbc:mysql://${mysql_host}/test \
  #--username trucker1 --password trucker --table TIMESHEET -m 1 \
  #--hcatalog-table TIMESHEET --hcatalog-storage-stanza "stored as orc" -m 1 --create-hcatalog-table
