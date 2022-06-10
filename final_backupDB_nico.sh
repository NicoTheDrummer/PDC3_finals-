#!/bin/bash

# WE'RE GONNA GO AHEAD AND CREATE A BACKUP FOLDER FOR OUR DB...
mkdir /opt/backups

# WE WILL THEN INSTALL THE GZIP PACKAGE....
yum install gzip -y

echo "YOU BOUTTA PUT IN THE INFO TO UPDATE FAM!"
# THIS PART WILL THEN CREATE A BACK UP OF OUR DB...
mysqldump -u nico -pbyun --databases wordpress | gzip > /opt/backups/wordpress_`date '+%m-%d-%Y'`.sql.gz

echo "YOU CREATED YOUR BACK UP!!!"