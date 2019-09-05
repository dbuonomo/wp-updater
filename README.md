# wp-updater
A shell script to update Wordpress core to the latest version. This follows manual update instructions here:

https://codex.wordpress.org/Upgrading_WordPress

Note: do not run this script without first making a full backup of your Wordpress site and related database.

## How-to

* Create a full backup of your Wordpress site (all files/folders and the database)
* Upload and run this script from your Wordpress root directory:

sh wp-update.sh {vhost filename}

## Notes

* This script has been tested with Apache 2.4.x
* The vhost file is assumed to be in /etc/apache2/sites-available
* This script must be run with sufficient privileges to delete and overrite some Wordpress files/directories
* Plugins are not updated, but this may be added in the future.
