!/bin/bash
source ./includes/basic.sh

echo "==================================================================================="
echo "| This script intent to install all necessary tools to work with a standard env   |"
echo "| for PHP development and also install all edge tools to make the work more       |"
echo "| productive and easy to do.                                                      |"
echo "| @version 1.0                                                                    |"
echo "| @author Klederson Bueno <klederson@klederson.com>                               |"
echo "| press [enter] to continue                                                       |"
echo "==================================================================================="

read nothing

chooseEnv;

echo "** Installing base tools and packages **"
echo "- GIT"
echo "- SVN"
echo "- OpenJDK 7"
echo "- MemCached"
echo "- OpenSSL"
echo "- ImageMagick"
echo "- GetText"

sudo apt-get -y install git-core subversion openjdk-7-jdk openjdk-7-jre wget memcached openssl gettext imagemagick build-essential || exit 1

echo "** Installing Apache 2 **"
sudo apt-get -y install apache2 apache2.2-common || exit 1
  
echo "** Installing MySQL 5 **"
sudo apt-get -y install mysql-server mysql-client || exit 1

echo "** Installing GetText **"
sudo apt-get -y build-dep gettext
sudo apt-get -y install gettext

echo "** Installing PHP 5.3.x **"
sudo apt-get -y install php5 php5-cli php5-imagick php5-common php5-curl php5-dev php5-gd php5-ldap php5-odbc php5-pgsql php-gettext php5-snmp php5-sybase php5-tidy php5-xmlrpc php5-xsl php5-intl php-pear php5-memcached libapache2-mod-php5 libapache2-mod-suphp php5-mysql || exit 1

echo "** Installing PHPUNIT for Unit Tests **"
sudo pear channel-discover pear.phpunit.de
sudo pear channel-discover pear.symfony-project.com
sudo pear install --alldeps phpunit/PHPUnit

PHPINFO="<?php
  phpinfo(); 
?>"
echo "Creating Test File phpinfo.php"
( cd /var/www ; echo "$PHPINFO" > phpinfo.php )
if [ "$ENV" = "DEV" ]; then
  NBVERSION=7.0.1
  NBNAME="netbeans-$NBVERSION-ml-php-linux.sh"
  NBURL="http://download.netbeans.org/netbeans/$NBVERSION/final/bundles/$NBNAME"
  
  mkdir -p ./downloads
  echo "** Starting Netbeans Installation **" 
  
  if [ -f "./downloads/$NBNAME" ]; then
    echo "OK! File Already Exists... we will use it to install"	
  else
    ( cd ./downloads/ ;  wget $NBURL || exit 1 )
  fi
  
  echo "- You need now configure netbeans steps to this instalation."
  echo "- Please remember that all plugin you need you must install later."
  echo "- This step can take a really LONG LONG TIME please have patience"
  echo "- press [enter] to continue"
  read nothing
  echo "#### PLEASE WAIT WHILE NETBEANS $NBVERSION IS INSTALLING ####"
  
  sudo sh ./downloads/$NBNAME --silent || exit 1
fi;

echo "** Configuring Apache **"
sudo a2enmod ssl
sudo a2enmod rewrite

echo "** Restarting Apache **" 
sudo /etc/init.d/apache2 restart || exit 1
echo "Instalação Finalizada abra o browser e digite http://localhost/phpinfo.php e confira sua instalação"
