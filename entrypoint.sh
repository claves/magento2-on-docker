#!/bin/sh
update-ca-certificates
php artisan optimize:clear
apache2-foreground
find var generated vendor pub app -type f -exec chmod g+wr {} +
find var generated vendor pub app -type d -exec chmod g+wrx {} +
chown -R magento:magento .
chmod u+x bin/magento
