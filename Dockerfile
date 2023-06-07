# Use RHEL 8 official base image
FROM redhat/ubi8:latest

# Reset PHP module
RUN dnf module reset php -y

# Enable PHP 7.4 module
RUN dnf module enable php:7.4 -y

# Install required packages
RUN dnf install -y httpd php php-mysqlnd php-gd php-xml mariadb-server mariadb php-mbstring php-json mod_ssl php-intl php-apcu

# Set working directory
WORKDIR /root

# Download MediaWiki tarball
RUN wget https://releases.wikimedia.org/mediawiki/1.39/mediawiki-1.39.3.tar.gz

# Download the GPG signature for the tarball
RUN wget https://releases.wikimedia.org/mediawiki/1.39/mediawiki-1.39.3.tar.gz.sig

# Change working directory to /var/www
WORKDIR /var/www

# Extract MediaWiki tarball
RUN tar -zxf /home/username/mediawiki-1.39.3.tar.gz

# Create symbolic link
RUN ln -s mediawiki-1.39.3/ mediawiki

# Configure firewall rules
RUN firewall-cmd --permanent --zone=public --add-service=http
RUN firewall-cmd --permanent --zone=public --add-service=https
RUN systemctl restart firewalld

# Adjust SELinux contexts
RUN restorecon -FR /var/www/mediawiki-1.39.3/
RUN restorecon -FR /var/www/mediawiki
EXPOSE 80
