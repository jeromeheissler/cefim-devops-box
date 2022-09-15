#!/bin/bash
echo ""
echo "==================================== Configuring Nginx... ===================================="
echo ""
chown www-data:www-data /var/www -R
rm /etc/nginx/sites-enabled/default
cp /vagrant_scripts/nginx.conf /etc/nginx/conf.d/default.conf
echo ""
echo "==================================== End of configuring Nginx... ===================================="
echo ""