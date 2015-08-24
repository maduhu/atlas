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


# The below code create the entities in atlas for Drivers and Timesheet table.
# The Drivers and Timesheet tables are pre fixed with type MYSQL to denote the source in TimeSheet
#

java -cp AtlasDemo1.jar:/usr/hdp/current/atlas-server/bridge/hive/*:/usr/hdp/current/atlas-server/hook/hive/* com.atlas.test.mysqlTypeCreator http://${hdp_host}:21000 test MYSQL_DRIVERS$1 MYSQL_TIMESHEET$1 nosearch

#
# The below line creates the entity for hive_table type
# hive table entities in atlas are created in the following format
# <databasename>.<tablename>@<clustername>
#

java -cp AtlasDemo1.jar:/usr/hdp/current/atlas-server/bridge/hive/*:/usr/hdp/current/atlas-server/hook/hive/* com.atlas.test.HiveMetaDataGenerator http://${hdp_host}:21000 atlasdemo default DRIVERS$1

#
# The below line creates the entity for hive_table type
# hive table entities in atlas are created in the following format
# <databasename>.<tablename>@<clustername>
#

java -cp AtlasDemo1.jar:/usr/hdp/current/atlas-server/bridge/hive/*:/usr/hdp/current/atlas-server/hook/hive/* com.atlas.test.HiveMetaDataGenerator http://${hdp_host}:21000 atlasdemo default TIMESHEET$1

#
# The below line creates the lineage between the mysql and the drivers table
#
java -cp AtlasDemo1.jar:/usr/hdp/current/atlas-server/bridge/hive/*:/usr/hdp/current/atlas-server/hook/hive/* com.atlas.test.AtlasEntityConnector http://${hdp_host}:21000 Table MYSQL_DRIVERS$1 hive_table default.DRIVERS$1@atlasdemo

#
# The below line creates the lineage between the mysql and the drivers table
#

java -cp AtlasDemo1.jar:/usr/hdp/current/atlas-server/bridge/hive/*:/usr/hdp/current/atlas-server/hook/hive/* com.atlas.test.AtlasEntityConnector http://${hdp_host}:21000 Table MYSQL_TIMESHEET$1 hive_table default.TIMESHEET$1@atlasdemo 

