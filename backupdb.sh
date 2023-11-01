#!/bin/sh
CONTAINER_NAME="db"
DB_USER="root"
DB_PASSWORD="${MYSQL_ROOT_PASSWORD}"
DB_NAME="databasename"
BACKUP_ROOT="/var/backups"
TIMESTAMP=$(date +"%F-%T")
FILENAME="backup-$TIMESTAMP-$DB_NAME.sql"

DAILY_DIR="$BACKUP_ROOT/daily"
mkdir -p $DAILY_DIR
BACKUP_PATH="$DAILY_DIR/$FILENAME"

mysqldump -h db -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_PATH
sed -i '/^mysqldump: \[Warning\]/d' $BACKUP_PATH

MONTHLY_DIR="$BACKUP_ROOT/monthly"
mkdir -p $MONTHLY_DIR

if [ $(date +"%d") -eq 1 ] ; then
  cp $BACKUP_PATH "$MONTHLY_DIR/$FILENAME"
fi

THREEMONTHS_DIR="$BACKUP_ROOT/threemonths"
mkdir -p $THREEMONTHS_DIR

if [ $(date +"%m") -eq 1 -o $(date +"%m") -eq 4 -o $(date +"%m") -eq 7 -o $(date +"%m") -eq 10 ] && [ $(date +"%d") -eq 1 ] ; then
  cp $BACKUP_PATH "$THREEMONTHS_DIR/$FILENAME"
fi

SIXMONTHS_DIR="$BACKUP_ROOT/sixmonths"
mkdir -p $SIXMONTHS_DIR

if [ $(date +"%m") -eq 1 -o $(date +"%m") -eq 7 ] && [ $(date +"%d") -eq 1 ] ; then
  cp $BACKUP_PATH "$SIXMONTHS_DIR/$FILENAME"
fi

echo "Fotas2 veritabanı yedekleme tamamlandı: $TIMESTAMP"
