#
#This table is used to clean up the drivers, timesheet and bad_drivers tables
#


sudo hive -e "drop table bad_drivers"
sudo hive -e "drop table timesheet"
sudo hive -e "drop table drivers"
