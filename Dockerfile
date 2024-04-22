# Use the latest version of the Amazon Linux base image
FROM amazonlinux:2023

# Update all installed packages to their latest versions
RUN yum update -y

# Install the unzip package, which we will use it to extract the web files from the zip folder
RUN yum install unzip -y

# Install wget package, which we will use it to download files from the internet
RUN yum install -y wget

# Install Apache
RUN yum install -y httpd

# Install PHP and various extensions
RUN yum install -y \
    php \
    php-common \
    php-pear \
    php-cgi \
    php-curl \
    php-mbstring \
    php-gd \
    php-mysqlnd \
    php-gettext \
    php-json \
    php-xml \
    php-fpm \
    php-intl \
    php-zip

# Install OpenSSL libraries from Amazon Linux EPEL repository
RUN amazon-linux-extras install -y epel
RUN yum install -y openssl-libs

# Download and install the MySQL repository package
RUN wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
RUN rpm -ivh mysql80-community-release-el7-3.noarch.rpm

# Install MySQL
RUN yum install -y mysql-community-server

# ... (rest of the Dockerfile remains the same)