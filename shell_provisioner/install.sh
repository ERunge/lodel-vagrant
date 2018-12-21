echo "::::: apt-get update :::::"
sudo apt-get update


echo "::::: apt-get install system dependencies:::::"
sudo -E apt-get install -y \
apache2 \
libapache2-mod-php \
libapache2-mod-php7.0 \
git \
php7.0 \
php7.0-cgi \
php7.0-cli \
php7.0-common \
php7.0-curl \
php7.0-gd \
php7.0-mbstring \
php7.0-mysql \
php7.0-xml \
php7.0-zip \
libxml2 \
mariadb-client \
mariadb-server \
vim

echo "::::: Apache lodel Vhost :::::"
rm /etc/apache2/sites-enabled/*.conf
echo '
<VirtualHost *:80>
	DocumentRoot /var/www/lodel/
	ErrorLog ${APACHE_LOG_DIR}/lodel_error.log
	CustomLog ${APACHE_LOG_DIR}/lodel_access.log combined
	<Directory "/var/www/lodel">
	  Order allow,deny
	  Allow from all
	</Directory>
</VirtualHost>
' > /etc/apache2/sites-enabled/lodel.conf



echo "::::: PHP Configuration :::::"
sudo sed -i 's/post_max_size =.*/post_max_size = 32M/' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/upload_max_filesize =.*/upload_max_filesize = 32M/' /etc/php/7.0/apache2/php.ini



echo "::::: Database installation :::::"
sudo mysql -u root -e "use mysql;
update user set password=PASSWORD('vagrant') where User='root';
update user set authentication_string=password('vagrant') where user='root';
update user set plugin='' where User = 'root';
CREATE USER 'lodel'@'localhost' IDENTIFIED BY 'lodelpassword';
CREATE DATABASE lodel;
GRANT ALL PRIVILEGES ON *.* TO 'lodel'@'localhost';
FLUSH PRIVILEGES;
quit"
sudo sh -c "echo 'max_allowed_packet=16M' >> /etc/mysql/my.cnf"
sudo sh -c "echo 'key_buffer_size=16M' >> /etc/mysql/my.cnf"
sudo service mysql restart


echo "::::: restarting Apache ... :::::"
sudo service apache2 restart


echo "::::: Git clone Lodel :::::"
cd /var/www
git clone --progress https://github.com/OpenEdition/lodel


echo "::::: CHOWN / CHMOD :::::"
cd lodel
chown -R www-data:www-data .
chmod -R 755 .


echo "::::: Lodel Configuration :::::"
cp /docs/lodelconfig.php lodelconfig.php
touch 03dde1bd-c6b6-4424-8618-c4488e30484a


echo "::::: Composer Installation :::::"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/bin
php -r "unlink('composer-setup.php');"
sudo chmod a+x /bin/composer.phar


echo "::::: Lodel Dependencies :::::"
cd lodel/scripts
composer.phar install


echo "
███████╗███╗   ██╗     ██╗ ██████╗ ██╗   ██╗██╗
██╔════╝████╗  ██║     ██║██╔═══██╗╚██╗ ██╔╝██║
█████╗  ██╔██╗ ██║     ██║██║   ██║ ╚████╔╝ ██║
██╔══╝  ██║╚██╗██║██   ██║██║   ██║  ╚██╔╝  ╚═╝
███████╗██║ ╚████║╚█████╔╝╚██████╔╝   ██║   ██╗
╚══════╝╚═╝  ╚═══╝ ╚════╝  ╚═════╝    ╚═╝   ╚═╝
"

echo "open http://10.0.0.200/lodeladmin/install.php and follow instructions"
echo " "
echo " "
