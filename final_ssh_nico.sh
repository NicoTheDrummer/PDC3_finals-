#!/bin/bash

# LET'S GO AHEAD AND INSTALL & START HTTPD SERVICE

yum install -y httpd
systemctl start httpd.service

# WE ADDING RULES FOR TRAFFIC TO BYPASS THE FIREWALL AND THE RELOAD IT

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

# WE INSTALLING PHP APACHE HERE AND ALSO RESTARTING IT

yum install -y php php-mysql
systemctl restart httpd.service
yum info php-fpm
yum install -y php-fpm

# WE ENTERING OUR HTML SITE TO CONFIG INDEX.PHP

cd /var/www/html/
echo '<?php phpinfo(); ?>' > index.php

# LET'S INSTALL RSYNC, TAR, WGET, UTILS, AND LATEST EPEL REMI NOW SO WE DON'T HAVE TO LATER ON

yum install -y rsync
echo "RSYNC INSTALLED"

yum install -y tar
echo "TAR INSTALLED"

yum install -y wget
echo "WGET INSTALLED"

yum install -y yum-utils
echo "UTILS INSTALLED"



# UPCOMING BLOCK WILL DOWNLOAD MARIADB

yum install -y mariadb-server mariadb
echo "YOU JUST INSTALLED MARIADB"

echo "COMMENCE OPERATION MARIADB"
systemctl start mariadb

# THIS UPCOMING COMMAND WILL AUTOMATE THE INPUTS NEEDED AND WILL ALSO PUT OUR EXTRA INFOS

mysql_secure_installation <<EOF

y
byun
byun
y
y
y
y
EOF

# WE JUST GONNA ENABLE MARIADB HERE...

systemctl enable mariadb
echo "MARIADB ENABLED"

# WE LOGGING INTO OUR DB NOW 
mysqladmin -u root -pbyun version

# WE ADDING OUR INFO FOR OUR WORDPRESS
echo "CREATE DATABASE wordpress; CREATE USER nico@localhost IDENTIFIED BY 'byun'; GRANT ALL PRIVILEGES ON wordpress.* TO nico@localhost IDENTIFIED BY 'byun'; FLUSH PRIVILEGES; show databases;" | mysql -u root -pbyun

# WE NOW INSTALLING WORDPRESS
yum install -y php-gd

# NEEDA RESTART APACHE
service httpd restart

# UPCOMING CODE KINDA TRICKY SO...WE GONNA GO AHEAD AND REDIRECT OUR CONTENTS AND CONFIGURE OUR PHP FILE

echo "DOWNLOADING FILE FOR OUR WORDPRESS"
cd /opt/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

echo "ADDING NEW DIRECTORY FOR WORDPRESS AT HOME"
rsync -avP wordpress/ /var/www/html/

# ENTERING HTML
cd /var/www/html/

echo "ADDING FOLDER IN WORDPRESS FOR STORAGE"
mkdir /var/www/html/wp-content/uploads

echo "MAKING FOLDER ACCESSIBLE"
chown -R apache:apache /var/www/html/*

echo "COPYING CONFIG FILE INTO FOLDER"
cp wp-config-sample.php wp-config.php

# FOLLOWING CODE WILL EDIT THE FILE AND INSERT OUR CREDENTIALS, AND THEN IT'LL REPLACE THE EXISTING WITH OUR INFOS
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/nico/g' wp-config.php
sed -i 's/password_here/byun/g' wp-config.php

# WE BOUTTA UPDATE PHP FAM 

yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php56
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
echo "SUCCESSFULLY UPDATED THE REPOS AND PHP!!!!"

# WE RESTARTING THE WHOLE SERVICE
systemctl restart httpd.service

echo "YOU'RE ALL DONE YOU BASTARD! YOU DID IT!!!! TIME TO GO SICKO MODE!!!!!"
