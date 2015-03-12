#!/bin/bash
mysqldump -uroot -pxxxxxx my_database > /opt/mysql_backup/dumps/my_database_`date +%Y%m%d`.dump
