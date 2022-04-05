# wp-updater
A shell script to update Wordpress core to the latest version on Apache. This follows manual update instructions here:

https://codex.wordpress.org/Upgrading_WordPress

Note: do not run this script without first making a full backup of your Wordpress site and related database.

## How-to

* Create a full backup of your Wordpress site (all files/folders and the database)
* Upload and run this script from your Wordpress root directory

sh wp-update.sh {domain}

Example

sh wp-update.sh mydomain.com

Answer the prompts.

## Notes

* This script has been tested with Apache 2.4.x
* The vhost files are assumed to be in /etc/apache2/sites-available
* wp-config.php will not be updated or modified
* This script must be run with sufficient privileges to delete and overrite some Wordpress files/directories
* Plugins are not updated, but this may be added in the future.
