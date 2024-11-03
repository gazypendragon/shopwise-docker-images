# FROM amazonlinux:2023

# # Update all installed packages to their latest versions
# RUN dnf update -y 

# # Install required packages
# RUN dnf install -y unzip wget httpd git

# # Enable and install PHP with extensions
# RUN dnf install -y php php-common php-pear php-cgi php-curl php-mbstring \
#     php-gd php-mysqlnd php-gettext php-json php-xml php-fpm php-intl php-zip

# # Install MySQL client and community server
# RUN wget https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm && \
#     rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 && \
#     dnf localinstall -y mysql80-community-release-el7-3.noarch.rpm && \
#     dnf install -y mysql-community-server

# # Set the working directory
# WORKDIR /var/www/html

# # Set the build arguments
# ARG PERSONAL_ACCESS_TOKEN
# ARG GITHUB_USERNAME
# ARG REPOSITORY_NAME
# ARG WEB_FILE_ZIP
# ARG DOMAIN_NAME
# ARG RDS_ENDPOINT
# ARG RDS_DB_NAME
# ARG RDS_DB_USERNAME
# ARG RDS_DB_PASSWORD

# # Set environment variables based on build arguments
# ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN \
#     GITHUB_USERNAME=$GITHUB_USERNAME \
#     REPOSITORY_NAME=$REPOSITORY_NAME \
#     WEB_FILE_ZIP=$WEB_FILE_ZIP \
#     DOMAIN_NAME=$DOMAIN_NAME \
#     RDS_ENDPOINT=$RDS_ENDPOINT \
#     RDS_DB_NAME=$RDS_DB_NAME \
#     RDS_DB_USERNAME=$RDS_DB_USERNAME \
#     RDS_DB_PASSWORD=$RDS_DB_PASSWORD

# # Clone the GitHub repository
# RUN git clone https://${PERSONAL_ACCESS_TOKEN}@github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git

# # Verify if the zip file exists and unzip, if it doesn’t exist, print an error message
# RUN if [ -f "${REPOSITORY_NAME}/${WEB_FILE_ZIP}" ]; then \
#         unzip ${REPOSITORY_NAME}/${WEB_FILE_ZIP} -d ${REPOSITORY_NAME}/; \
#     else \
#         echo "Error: ${WEB_FILE_ZIP} not found in ${REPOSITORY_NAME}"; \
#         exit 1; \
#     fi

# # Copy web files to the HTML directory and clean up
# RUN cp -av ${REPOSITORY_NAME}/. /var/www/html && rm -rf ${REPOSITORY_NAME}

# # Configure Apache settings
# RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# # Update permissions
# RUN chmod -R 777 /var/www/html && chmod -R 777 /var/www/html/storage

# # Update environment variables in .env file
# RUN sed -i "/^APP_ENV=/ s/=.*$/=production/" .env && \
#     sed -i "/^APP_URL=/ s/=.*$/=https:\/\/${DOMAIN_NAME}\//" .env && \
#     sed -i "/^DB_HOST=/ s/=.*$/=${RDS_ENDPOINT}/" .env && \
#     sed -i "/^DB_DATABASE=/ s/=.*$/=${RDS_DB_NAME}/" .env && \
#     sed -i "/^DB_USERNAME=/ s/=.*$/=${RDS_DB_USERNAME}/" .env && \
#     sed -i "/^DB_PASSWORD=/ s/=.*$/=${RDS_DB_PASSWORD}/" .env

# # Display the .env file for verification
# RUN cat .env

# # Copy AppServiceProvider.php to container
# COPY AppServiceProvider.php app/Providers/AppServiceProvider.php

# # Expose required ports
# EXPOSE 80 3306

# # Start Apache in the foreground
# ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]


FROM amazonlinux:2023

# Update all installed packages
RUN dnf update -y

# Install required packages including MySQL 8.0 compatibility libraries
RUN dnf install -y unzip wget httpd git openssl11

# Create symbolic links for compatibility with MySQL 8
RUN ln -s /usr/lib64/libssl.so.1.1 /usr/lib64/libssl.so.10 && \
    ln -s /usr/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.10

# Download and install MySQL 8.0 repository
RUN wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm && \
    rpm -ivh mysql80-community-release-el7-3.noarch.rpm && \
    dnf install -y mysql-community-server

# Enable and install PHP with extensions
RUN dnf install -y php php-common php-pear php-cgi php-curl php-mbstring \
    php-gd php-mysqlnd php-gettext php-json php-xml php-fpm php-intl php-zip

# Set the working directory
WORKDIR /var/www/html

# Set build arguments
ARG PERSONAL_ACCESS_TOKEN
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
ARG WEB_FILE_ZIP
ARG DOMAIN_NAME
ARG RDS_ENDPOINT
ARG RDS_DB_NAME
ARG RDS_DB_USERNAME
ARG RDS_DB_PASSWORD

# Set environment variables based on build arguments
ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN \
    GITHUB_USERNAME=$GITHUB_USERNAME \
    REPOSITORY_NAME=$REPOSITORY_NAME \
    WEB_FILE_ZIP=$WEB_FILE_ZIP \
    DOMAIN_NAME=$DOMAIN_NAME \
    RDS_ENDPOINT=$RDS_ENDPOINT \
    RDS_DB_NAME=$RDS_DB_NAME \
    RDS_DB_USERNAME=$RDS_DB_USERNAME \
    RDS_DB_PASSWORD=$RDS_DB_PASSWORD

# Clone the GitHub repository
RUN git clone https://${PERSONAL_ACCESS_TOKEN}@github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git

# Verify if the zip file exists and unzip it
RUN if [ -f "${REPOSITORY_NAME}/${WEB_FILE_ZIP}" ]; then \
        unzip ${REPOSITORY_NAME}/${WEB_FILE_ZIP} -d ${REPOSITORY_NAME}/; \
    else \
        echo "Error: ${WEB_FILE_ZIP} not found in ${REPOSITORY_NAME}"; \
        exit 1; \
    fi

# Copy web files to the HTML directory and clean up
RUN cp -av ${REPOSITORY_NAME}/. /var/www/html && rm -rf ${REPOSITORY_NAME}

# Configure Apache settings
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Update permissions
RUN chmod -R 777 /var/www/html && chmod -R 777 /var/www/html/storage

# Update environment variables in .env file
RUN sed -i "/^APP_ENV=/ s/=.*$/=production/" .env && \
    sed -i "/^APP_URL=/ s/=.*$/=https:\/\/${DOMAIN_NAME}\//" .env && \
    sed -i "/^DB_HOST=/ s/=.*$/=${RDS_ENDPOINT}/" .env && \
    sed -i "/^DB_DATABASE=/ s/=.*$/=${RDS_DB_NAME}/" .env && \
    sed -i "/^DB_USERNAME=/ s/=.*$/=${RDS_DB_USERNAME}/" .env && \
    sed -i "/^DB_PASSWORD=/ s/=.*$/=${RDS_DB_PASSWORD}/" .env

# Display the .env file for verification
RUN cat .env

# Copy AppServiceProvider.php to container
COPY AppServiceProvider.php app/Providers/AppServiceProvider.php

# Expose required ports
EXPOSE 80 3306

# Start Apache and MySQL
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
