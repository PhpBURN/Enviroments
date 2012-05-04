#!/bin/bash

currdate=`date +%F%H%M%S`
home="/home/ubuntu"
backup_folder="$home/backups"
uploads_dir="$home/uploads"
database="Gnoose"
dbuser="gnoose"

echo "-- Type application folder name (only not full just folder name ex: www.gnoose.com)"
read site_folder

echo "-- Preparing folders and Files"
mkdir -p "$backup_folder/$currdate/"
cd "$backup_folder/$currdate"

echo "-- Performing Database Backup (need password)"
mysqldump -u $dbuser -p $database > database.sql | exit 1

echo "-- Performing backup of application files/core"
tar -cvf application.tar "$home/www/$site_folder"

echo "-- Performing backup of uploaded files"
tar -cvf uploads.tar "$uploads_dir"

echo "################ BACKUP FINISHED ################"
