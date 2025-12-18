#!/bin/bash

# ----------------------------------------
# Laravel Setup Script for WSL (Ubuntu)
# PHP 7.4 / Laravel 6-8 Compatible
# ----------------------------------------

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y curl git unzip software-properties-common build-essential

# Add PHP PPA
echo "Adding PHP repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP 7.4 and extensions
echo "Installing PHP 7.4 and extensions..."
sudo apt install -y php7.4 php7.4-cli php7.4-common php7.4-mbstring php7.4-xml php7.4-mysql php7.4-zip php7.4-curl php7.4-gd php7.4-bcmath php7.4-soap php7.4-intl php7.4-tokenizer php7.4-json

# Install Apache
echo "Installing Apache..."
sudo apt install -y apache2 libapache2-mod-php7.4
sudo a2enmod rewrite

# Install Composer
echo "Installing Composer..."
cd ~
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# Install MySQL (optional)
echo "Installing MySQL..."
sudo apt install -y mysql-server
sudo service mysql start

# Optional: create a database and user
# Uncomment and edit as needed
# echo "Creating database..."
# mysql -u root -e "CREATE DATABASE laravel_db;"
# mysql -u root -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'password';"
# mysql -u root -e "GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';"
# mysql -u root -e "FLUSH PRIVILEGES;"

# Create a Laravel project folder
echo "Creating Laravel project folder..."
read -p "Enter your Laravel project path (full path): " PROJECT_PATH
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# If starting a new project
# composer create-project --prefer-dist laravel/laravel .

# If cloning an existing project
# git clone <repo-url> .
# composer install

# Set permissions
echo "Setting folder permissions..."
sudo chown -R $USER:www-data "$PROJECT_PATH"/storage "$PROJECT_PATH"/bootstrap/cache
sudo chmod -R 775 "$PROJECT_PATH"/storage "$PROJECT_PATH"/bootstrap/cache

# Configure Apache virtual host
echo "Configuring Apache..."
VHOST_CONF="/etc/apache2/sites-available/000-default.conf"
sudo bash -c "cat > $VHOST_CONF <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $PROJECT_PATH/public

    <Directory $PROJECT_PATH/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL"

sudo service apache2 restart

echo "----------------------------------------"
echo "Setup complete!"
echo "You can now access your Laravel app at http://localhost"
echo "For development, you can also run: php artisan serve"
echo "----------------------------------------"
