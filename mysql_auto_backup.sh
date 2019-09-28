#!/bin/bash
#auto backup mysql
BACKDIR=/tmp/backup/mysql/`date +%F`
MYSQLDB=xuegod1
MYSQLUSER=root
MYSQLPW=zy4231351
# must use root user to run scripts
if [ $UID -ne 0 ]; then
	echo "the user must be root, permission denen!"
	sleep 2
	exit 0
fi
# is the dictionary exit?
if [ ! -d $BACKDIR ]; then
	mkdir -p $BACKDIR
else
	echo "the dictionary $BACKDIR exits"
	exit
fi
# use musqldump backup mysql
/usr/bin/mysqldump -u$MYSQLUSER -p$MYSQLPW $MYSQLDB > $BACKDIR/${MYSQLDB}_db.sql
cd $BACKDIR
tar -czf $BACKDIR/${MYSQLDB}_db.tar.gz ./*_db.sql
find $BACKDIR -type f -name *_db.sql -exec rm -rf {} \;
[ $? -eq 0 ] && echo "this `date +%F` mysql backup is SUCCESS"
cd $BACKDIR/.. && find -type d -mtime +30 |xargs rm -rf {} \;
echo "the mysql backup is successful"

