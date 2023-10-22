#!/bin/bash

# Check for updates and upgrade
sudo apt update
sudo apt -y upgrade

# Install Apache
sudo apt install apache2

# Install MySQL
sudo apt install mysql-server

# Install PHP and all modules
sudo apt install $PHP-fpm libapache2-mod-$PHP $PHP-cli $PHP-common $PHP-mysql $PHP-opcache $PHP-soap $PHP-zip $PHP-intl $PHP-bcmath $PHP-xml $PHP-xmlrpc $PHP-curl $PHP-gd $PHP-imagick $PHP-cl>

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } el>
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Clone laravel project
git clone git@github.com:laravel/laravel.git laravel

# Copy project to www
sudo cp -r laravel /var/www/

# Set project permissions
sudo chown -R $USER:$USER /var/www/laravel

# Create virtual host file
sudo touch /etc/apache2/sites-available/laravel.conf

# Add virtual host content
cat > /etc/apache2/sites-available/laravel.conf << EOL
<VirtualHost *:80>
    ServerName laravel
    ServerAlias www.laravel.test
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/laravel
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL


# Set server uptime cronjob at every 12am - midnight
ansible-playbook create_cron.yml


