#!/bin/sh

while true; do
    read -p "Backup your Wordpress site before proceeding! Do you wish to continue (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

#vhosts=`grep -l "ServerName[[:blank:]].*$1" /etc/apache2/sites-available/*`
file="/etc/apache2/sites-available/$1"
if [ ! -f "$file" ]
then
    echo "Vhost file $file not found."
    echo "Update aborted."
    exit 1
fi

if [ ! -d "wp-includes" ]; then
    echo This doesn\'t appear to be a Wordpress root directory.
    echo "Update aborted."
    exit 1
fi

echo Downloading Wordpress...
wget -q https://wordpress.org/latest.zip
mkdir -p wp-download
unzip -qq latest.zip -d wp-download

cver=`grep '^\$wp_version' wp-includes/version.php | sed "s/^.*'\(.*\)'.*$/\1/"`
nver=`grep '^\$wp_version' wp-download/wordpress/wp-includes/version.php | sed "s/^.*'\(.*\)'.*$/\1/"`

while true; do
    read -p "Wordpress will be updated from v$cver to v$nver. Do you wish to continue (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) rm -rf latest.zip wp-download; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo Update starts in 5 seconds, type Ctrl+c to abort...
sleep 5

echo Disabling $1...
sleep 2
#a2dissite -q $vhosts
a2dissite -q $1
service apache2 reload

echo Updating Wordpress...
rm -rf wp-admin wp-includes
cp -rf wp-download/wordpress/* .

echo Enabling $1...
sleep 2
#a2ensite -q $vhosts
a2ensite -q $1
service apache2 reload

echo 'Cleanup...'
rm -rf latest.zip wp-download

echo wp-config.php not updated. You must manually diff and merge any new changes from wp-config-sample.php.
echo Update complete.
exit 0
