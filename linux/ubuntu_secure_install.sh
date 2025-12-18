#!/bin/bash

# =========================================================
# Secure Ubuntu 20.04 Server Setup for Laravel 8 + PHP 7.4
# =========================================================

set -e

# ---------------- VARIABLES ----------------
MYSQL_ROOT_PASSWORD="Biam@2025!123"
SSH_PORT=2222
LARAVEL_USER="mdadalkhan"
LARAVEL_PATH="/var/www/src"
USE_NGINX=false          # true = nginx, false = apache
DOMAIN_NAME="tms.biam.gov.bd"

# ---------------- 1. SYSTEM UPDATE ----------------
echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    unattended-upgrades \
    apt-listchanges \
    software-properties-common \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    curl git unzip ufw fail2ban

# ---------------- 2. FIREWALL ----------------
echo "[*] Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ${SSH_PORT}/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# ---------------- 3. SSH HARDENING ----------------
echo "[*] Hardening SSH..."
sudo sed -i "s/^#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config
sudo sed -i "s/^PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sudo sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sudo systemctl restart sshd

# ---------------- 4. PHP 7.4 ----------------
echo "[*] Installing PHP 7.4..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

sudo apt install -y \
    php7.4 php7.4-cli php7.4-common php7.4-mbstring php7.4-xml \
    php7.4-bcmath php7.4-curl php7.4-mysql php7.4-zip \
    php7.4-fpm

# Light PHP hardening (SAFE for Laravel)
PHP_INI="/etc/php/7.4/apache2/php.ini"
sudo sed -i "s/expose_php = On/expose_php = Off/" $PHP_INI
sudo sed -i "s/display_errors = On/display_errors = Off/" $PHP_INI

# ---------------- 5. WEB SERVER ----------------
if [ "$USE_NGINX" = true ]; then
    echo "[*] Installing Nginx..."
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
else
    echo "[*] Installing Apache..."
    sudo apt install -y apache2 libapache2-mod-php7.4
    sudo a2enmod rewrite
    sudo systemctl enable apache2
    sudo systemctl start apache2
fi

# ---------------- 6. LARAVEL DIRECTORY ----------------
echo "[*] Setting up Laravel directory..."
sudo mkdir -p $LARAVEL_PATH
sudo chown -R $LARAVEL_USER:www-data $LARAVEL_PATH
sudo chmod -R 755 $LARAVEL_PATH

# Required Laravel permissions
sudo chown -R www-data:www-data \
    $LARAVEL_PATH/storage \
    $LARAVEL_PATH/bootstrap/cache

sudo chmod -R 775 \
    $LARAVEL_PATH/storage \
    $LARAVEL_PATH/bootstrap/cache

# ---------------- 7. COMPOSER ----------------
echo "[*] Installing Composer..."
if ! command -v composer >/dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# ---------------- 8. MYSQL ----------------
echo "[*] Installing MySQL..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

sudo mysql -e "
ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
"

# ---------------- 9. FAIL2BAN ----------------
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# ---------------- 10. APACHE VHOST ----------------
if [ "$USE_NGINX" = false ]; then
    echo "[*] Configuring Apache VirtualHost..."

    APACHE_CONF="/etc/apache2/sites-available/laravel.conf"
    sudo tee $APACHE_CONF >/dev/null <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN_NAME}
    DocumentRoot ${LARAVEL_PATH}/public

    <Directory ${LARAVEL_PATH}/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/laravel-error.log
    CustomLog \${APACHE_LOG_DIR}/laravel-access.log combined
</VirtualHost>
EOF

    sudo a2ensite laravel.conf
    sudo a2dissite 000-default.conf
    sudo systemctl reload apache2
fi

# ---------------- 11. LARAVEL INIT ----------------
echo "[*] Initializing Laravel..."
cd $LARAVEL_PATH

if [ -f artisan ]; then
    if [ ! -f ".env" ]; then
        cp .env.example .env
    fi

    php artisan key:generate --force
    php artisan optimize:clear
    sudo truncate -s 0 storage/logs/laravel.log
fi

# ---------------- DONE ----------------
echo "====================================="
echo "Laravel 8 + PHP 7.4 SERVER READY"
echo "SSH Port : $SSH_PORT"
echo "Path     : $LARAVEL_PATH"
echo "PHP      : $(php -v | head -n 1)"
echo "====================================="
