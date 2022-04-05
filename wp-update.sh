#!/bin/sh

while true; do
    read -p "Backup your Wordpress site before proceeding! Do you wish to continue (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

vhosts=`grep -l "ServerName[[:blank:]].*$1" /etc/apache2/sites-available/*`
if [ -z "$vhosts" ]
then
    echo "No matching vhost files, exiting..."
    exit 1
fi

if [ ! -d "wp-includes" ]; then
    echo This doesn\'t appear to be a Wordpress root directory, exiting....
    exit 1
fi

echo "Matching vhost files..."
echo $vhosts

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
for vhost in $vhosts; do
    #a2dissite -q $(basename -- "$vhost")
    a2dissite $(basename -- "$vhost")
done
service apache2 reload

echo Updating Wordpress...
rm -rf wp-admin wp-includes
cp -rf wp-download/wordpress/* .

echo Enabling $1...
for vhost in $vhosts; do
    #a2ensite -q $(basename -- "$vhost")
    a2ensite $(basename -- "$vhost")
done
service apache2 reload

echo 'Cleanup...'
rm -rf latest.zip wp-download

echo wp-config.php not updated. You must manually diff and merge any new changes from wp-config-sample.php.
echo Update complete.
exit 0

