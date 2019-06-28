#!/bin/bash

DATABASE="xwiki"
DBUSER=xwiki
DBPASS=xwiki

#XWIKI data folder
DATA_DIR=/var/lib/xwiki/data
CONFIG_DIR=/etc/xwiki

cd /root

echo "Removing old backups!"
find . -type f -iname "*.tar.gz" -mtime +5 -delete

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE=$(date '+%Y-%m-%d')
mkdir ./${DATE}

#backup mysql
echo "Backing up database!"
pg_dump -h localhost -U postgres xwiki > ./${DATE}/database-backup.sql

echo "Backing up xwiki data!"
#Backup Exteral Data Storage
/bin/tar -C ${DATA_DIR}/../ -zcf ./${DATE}/data.tar.gz data

echo "Backing up xwiki configuration!"
/bin/cp ${CONFIG_DIR}/hibernate.cfg.xml ./${DATE}/hibernate.cfg.xml
/bin/cp ${CONFIG_DIR}/xwiki.cfg ./${DATE}/xwiki.cfg
/bin/cp ${CONFIG_DIR}/xwiki.properties ./${DATE}/xwiki.properties

echo "Compressing all backup file!"
/bin/tar -zcvf ${DATE}.tar.gz ${DATE}

echo "Removing ${DATE} directory!"
rm -rf ${DATE}

echo "Done!"