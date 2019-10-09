#! /usr/bin/env bash

# Monitor Atlassian XML Backup creation using PRTG SSH Script Sensor
# Return error code if no backup file was created during the last n hours
MAXAGE=25


# Identify Atlassian app
APP=$(find /var/atlassian/application-data -mindepth 1  -maxdepth 1 -type d -printf '%f\n')

case $APP in
     confluence)
          BACKUPDIR=/var/atlassian/application-data/confluence/backups
          ;;
     jira)
          BACKUPDIR=/var/atlassian/application-data/jira/export
          ;;
     bitbucket)
          BACKUPDIR=/var/atlassian/application-data/bitbucket/export
          ;; 
     *)
          echo "2:$?:No supported Atlassian application (Confluence, Jira, Bitbucket) found"; exit
          ;;
esac

BACKUPFILE=$(find $BACKUPDIR -maxdepth 1 -name "*.zip" -newermt "$MAXAGE hours ago" -printf "%T@ %f\n" | sort -n | cut -d' ' -f 2- | tail -n 1 | egrep '.*')

if [ $? -ne 0 ]; then
  echo "2:$?:No backup created during last $MAXAGE hours"
else
  echo "0:$?:OK ($BACKUPFILE)"
fi
