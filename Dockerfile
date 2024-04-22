# Use the latest Amazon Linux base image
FROM amazonlinux:latest

# Update all installed packages to their latest versions
RUN yum update -y

# Install necessary utilities
RUN yum install -y wget unzip

# Install Apache and PHP
RUN yum install -y httpd php php-pdo php-openssl php-mbstring php-exif php-fileinfo php-xml php-ctype php-json php-tokenizer php-curl php-cli php-fpm php-mysqlnd php-bcmath php-gd php-cgi php-gettext php-intl php-zip

# Install MySQL 8
RUN wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm \
    && rpm -ivh mysql80-community-release-el7-1.noarch.rpm \
    && rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 \
    && yum install -y mysql-community-server \
    && systemctl start mysqld \
    && systemctl enable mysqld

# Enable mod_rewrite module in Apache
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Install AWS CLI (assuming it's needed for syncing from S3)
RUN yum install -y aws-cli

# Set environment variable
ENV S3_BUCKET_NAME=shopwise-project-web-files

# Sync content from S3 bucket to /var/www/html
RUN aws s3 sync s3://$S3_BUCKET_NAME /var/www/html

# Set working directory
WORKDIR /var/www/html

# Extract application code
RUN unzip shopwise.zip \
    && cp -R shopwise/. /var/www/html/ \
    && rm -rf shopwise shopwise.zip

# Set permissions
RUN chmod -R 777 /var/www/html \
    && chmod -R 777 storage/

# Change directory to the html directory
WORKDIR /var/www/html

# Install Git
RUN yum install -y git

# Set the build argument directive
ARG PERSONAL_ACCESS_TOKEN
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
#ARG WEB_FILE_ZIP
ARG WEB_FILE_UNZIP
ARG DOMAIN_NAME
ARG RDS_ENDPOINT
ARG RDS_DB_NAME
ARG RDS_DB_USERNAME
ARG RDS_DB_PASSWORD

# Use the build argument to set environment variables
ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_USERNAME=$GITHUB_USERNAME
ENV REPOSITORY_NAME=$REPOSITORY_NAME
#ENV WEB_FILE_ZIP=$WEB_FILE_ZIP
ENV WEB_FILE_UNZIP=$WEB_FILE_UNZIP
ENV DOMAIN_NAME=$DOMAIN_NAME
ENV RDS_ENDPOINT=$RDS_ENDPOINT
ENV RDS_DB_NAME=$RDS_DB_NAME
ENV RDS_DB_USERNAME=$RDS_DB_USERNAME
ENV RDS_DB_PASSWORD=$RDS_DB_PASSWORD

# Clone the GitHub repository
RUN git clone https://${PERSONAL_ACCESS_TOKEN}@github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git

# Unzip the zip folder containing the web files
#RUN unzip ${REPOSITORY_NAME}/${WEB_FILE_ZIP} -d ${REPOSITORY_NAME}/

# Copy the web files into the HTML directory
RUN cp -av ${REPOSITORY_NAME}/. /var/www/html

# Remove the repository we cloned
RUN rm -rf ${REPOSITORY_NAME}

# Enable the mod_rewrite setting in the httpd.conf file
RUN sed -i '/<Directory "\\/var\\/www\\/html">/,/<\\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Give full access to the /var/www/html directory
RUN chmod -R 777 /var/www/html

# Give full access to the storage directory
RUN chmod -R 777 storage/

# Use the sed command to search the .env file for a line that starts with APP_ENV= and replace everything after the = character
RUN sed -i '/^APP_ENV=/ s/=.\*$/=production/' .env

# Use the sed command to search the .env file for a line that starts with APP_URL= and replace everything after the = character
RUN sed -i "/^APP_URL=/ s/=.\*$/=https:\\/\\/${DOMAIN_NAME}\\//" .env

# Use the sed command to search the .env file for a line that starts with DB_HOST= and replace everything after the = character
RUN sed -i "/^DB_HOST=/ s/=.\*$/=${RDS_ENDPOINT}/" .env

# Use the sed command to search the .env file for a line that starts with DB_DATABASE= and replace everything after the = character
RUN sed -i "/^DB_DATABASE=/ s/=.\*$/=${RDS_DB_NAME}/" .env

# Use the sed command to search the .env file for a line that starts with DB_USERNAME= and replace everything after the = character
RUN  sed -i "/^DB_USERNAME=/ s/=.\*$/=${RDS_DB_USERNAME}/" .env

# Use the sed command to search the .env file for a line that starts with DB_PASSWORD= and replace everything after the = character
RUN  sed -i "/^DB_PASSWORD=/ s/=.\*$/=${RDS_DB_PASSWORD}/" .env

# Print the .env file to review values
RUN cat .env

# Copy the file, AppServiceProvider.php from the host file system into the container at the path app/Providers/AppServiceProvider.php
COPY AppServiceProvider.php app/Providers/AppServiceProvider.php

# Expose the default Apache and MySQL ports
EXPOSE 80 3306

# Start Apache and MySQL
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]