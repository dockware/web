# Official Dockware Image
# Copyright 2025 dasistweb GmbH
#
FROM ubuntu:22.04
LABEL title="Dockware flex:latest" \
      version="1.8.0" \
      maintainer="dasistweb GmbH"

# remember build-date
RUN date >/build-date.txt && \
    mkdir -p /var/www && \
    mkdir -p /var/www/scripts

# add our changelog to the containers
ADD ./assets/CHANGELOG.md /var/www/CHANGELOG.md

## ***********************************************************************
##  IMAGE VARIABLES
## ***********************************************************************
ENV TZ Europe/Berlin
ENV PHP_VERSION 7.4
ENV APACHE_DOCROOT /var/www/html/public
ENV SW_TASKS_ENABLED 0
ENV COMPOSER_VERSION not-set
ENV NODE_VERSION 12
ENV SHOP_DOMAIN localhost
ENV RECOVERY_MODE 0
RUN echo "export TZ=${TZ}" >> /etc/profile \
 && echo "export PHP_VERSION=${PHP_VERSION}" >> /etc/profile \
 && echo "export APACHE_DOCROOT=${APACHE_DOCROOT}" >> /etc/profile \
 && echo "export SW_TASKS_ENABLED=${SW_TASKS_ENABLED}" >> /etc/profile \
 && echo "export COMPOSER_VERSION=${COMPOSER_VERSION}" >> /etc/profile \
 && echo "export NODE_VERSION=${NODE_VERSION}" >> /etc/profile \
 && echo "export SHOP_DOMAIN=${SHOP_DOMAIN}" >> /etc/profile \
 && echo "export RECOVERY_MODE=${RECOVERY_MODE}" >> /etc/profile

COPY --chmod=0755 ./config/php/general.ini /tmp/general.ini
COPY --chmod=0755 ./config/php/cli.ini /tmp/cli.ini

ENV SSH_USER not-set
ENV SSH_PWD not-set
ENV XDEBUG_REMOTE_HOST "host.docker.internal"
ENV XDEBUG_CONFIG "idekey=PHPSTORM"
ENV PHP_IDE_CONFIG "serverName=localhost"
ENV XDEBUG_ENABLED 0
ENV FILEBEAT_ENABLED 0
ENV TIDEWAYS_KEY not-set
ENV TIDEWAYS_ENV production
ENV BASH_ENV /var/www/.bashrc
ENV SW_API_ACCESS_KEY 'not-set'

COPY --chmod=0755 ./config/tideways/tideways.ini /tmp/tideways.ini
COPY --chmod=0755 ./scripts /tmp/scripts

COPY --chmod=0755 ./assets/scripts/makefile /var/www/makefile
COPY --chmod=0755 ./assets/scripts/bin /var/www/scripts/bin
COPY --chmod=0755 ./assets/scripts/cron /var/www/scripts/cron
COPY --chmod=0755 entrypoint.sh /entrypoint.sh

# -------------------------------------------------------------------------------------------------------


RUN echo "export SSH_USER=${SSH_USER}" >> /etc/profile \
    && echo "export SSH_PWD=${SSH_PWD}" >> /etc/profile \
    && echo "export XDEBUG_ENABLED=${XDEBUG_ENABLED}" >> /etc/profile \
    && echo "export XDEBUG_REMOTE_HOST=${XDEBUG_REMOTE_HOST}" >> /etc/profile \
    && echo "export XDEBUG_CONFIG=${XDEBUG_CONFIG}" >> /etc/profile \
    && echo "export PHP_IDE_CONFIG=${PHP_IDE_CONFIG}" >> /etc/profile \
    && echo "export FILEBEAT_ENABLED=${FILEBEAT_ENABLED}" >> /etc/profile \
    && echo "export TIDEWAYS_KEY=${TIDEWAYS_KEY}" >> /etc/profile \
    && echo "export TIDEWAYS_ENV=${TIDEWAYS_ENV}" >> /etc/profile \
    && echo "export SW_API_ACCESS_KEY=${SW_API_ACCESS_KEY}" >> /etc/profile

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  BASE REQUIREMENTS
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RUN apt-get update && \
    # first install tools to add repositories
    apt-get install -y wget gnupg2 sudo apt-transport-https software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list && \
    sudo echo 'deb [signed-by=/usr/share/keyrings/tideways.gpg] https://packages.tideways.com/apt-packages-main any-version main' | sudo tee /etc/apt/sources.list.d/tideways.list && \
    wget -qO - 'https://packages.tideways.com/key.gpg' | gpg --dearmor | sudo tee /usr/share/keyrings/tideways.gpg > /dev/null && \
    # update our repositories
    apt-get update && \
    # now have fun installing stuff
    apt-get install -y  gosu \
                        curl \
                        unzip \
                        bzip2 \
                        ssmtp \
                        lsof \
                        openssh-server \
                        cron \
                        vim \
                        nano \
                        jq \
                        gpg-agent \
                        rsync \
                        sshpass \
                        jpegoptim \
                        screen \
                        mysql-client \
                        git \
                        chromium-browser \
                        filebeat && \
    mkdir /var/run/sshd && \
    # TIMEZONE SETTINGS, otherwise we would have an interactive input dialog
    ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    echo "Europe/Berlin" > /etc/timezone


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  USER MANAGEMENT
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# set easy root pwd for dev purpose
RUN echo "root:root" | chpasswd \
    # set password for www-data, and also
    # avoid shell login (we have a separate user for that)
    echo 'www-data:www-data' | chpasswd && \
    usermod -s /usr/sbin/nologin www-data && \
    # this option makes sure to avoid root SSH login
    # we just replace our lines with nothing
    sed -i 's/PermitRootLogin without-password//' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password//' /etc/ssh/sshd_config && \
    # allow root and sudo group to run sudo without password
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g'  &&\
    # remove include directory
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    # add our dockware user
    adduser --disabled-password --uid 5577 --gecos "" --ingroup www-data dockware && \
    -m -d /var/www dockware | true && \
    echo "dockware:dockware" | chpasswd && \
    usermod -a -G sudo dockware && \
    # allow sudo without pwd and dont require tty (for entrypoint commands)
    echo "Defaults:dockware !requiretty" >> /etc/sudoers && \
    sed -i 's/dockware:x:5577:33:/dockware:x:33:33:/g' /etc/passwd && \
    echo 'AllowUsers dockware' >> /etc/ssh/sshd_config


# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  APACHE INSTALLATION
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RUN apt-get install -y apache2 libapache2-mod-fcgid

# immediately after installing apache, we have to overwrite the default configuration before proceeding with a2enmod
COPY --chmod=0755 ./config/apache/http2.conf /etc/apache2/conf-available/http2.conf
COPY --chmod=0755 ./config/apache/apache2.conf /etc/apache2/apache2.conf
COPY --chmod=0755 ./config/apache/ports.conf /etc/apache2/ports.conf
COPY --chmod=0755 ./config/apache/sites.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod headers && \
    a2enmod rewrite && \
    a2enmod expires && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod proxy_wstunnel && \
    a2enmod actions && \
    a2enmod fcgid && \
    a2enmod alias && \
    a2enmod proxy_fcgi && \
    a2enmod http2 && \
    sudo a2enconf http2 && \
    sudo a2dismod mpm_prefork > /dev/null 2>&1 && \
    sudo a2enmod mpm_event > /dev/null 2>&1 && \
    # remove the standard apache index file
    mkdir -p /var/www/html && \
    rm -rf /var/www/html/* && \
    chown -R www-data:www-data /var/www/html && \
    sudo -u www-data sh -c 'mkdir -p /var/www/html/public'  && \
    # make sure the configured log folder exists and is writeable
    chmod -R 0777 /var/www && \
    chgrp -R www-data /var/log/apache2 && \
    mkdir -p /var/log/mysql && \
    chgrp -R www-data /var/log/mysql &&\
    mkdir /var/log/php -p  && \
    touch /var/log/php/cli_errors.log && \
    touch /var/log/php/fpm_errors.log && \
    chown -R www-data:www-data /var/log/php && \
    chmod 0755 /var/log/php




# create a new id_rsa for the www-data dockeruser.
# thus we have a SSH Key for connections out of the box
RUN mkdir -p /var/www/.ssh && \
    rm -rf /var/www/.ssh/id_rsa; true && \
    rm -rf /var/www/.ssh/id_rsa.pub; true && \
    ssh-keygen -t rsa -b 4096 -f /var/www/.ssh/id_rsa -C "Dockware Container" -P "" && \
    chown -R www-data:www-data /var/www/.ssh && \
    chmod 0700 /var/www/.ssh




# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  PHP INSTALLATION
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RUN cd /tmp/scripts && sh install_php.sh



## ***********************************************************************
##  MOD_SSL
##  create SSL certificate
## ***********************************************************************
RUN apt-get install -y openssl \
    && a2enmod ssl \
    && mkdir /etc/apache2/ssl \
    && openssl req -new -x509 -days 365 -sha1 -newkey rsa:2048 -nodes -keyout /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.crt -subj '/O=Company/OU=Department/CN=localhost'



RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp --version=2.2.9 --quiet \
    # prepare "global" composer directory for www-data
    && mkdir -p /var/www/.composer \
    && export COMPOSER_HOME="/var/www/.composer" \
    && chmod 755 /tmp/composer.phar \
    && mv /tmp/composer.phar /usr/local/bin/composer



## ***********************************************************************
##  NODE INSTALLATION
## ***********************************************************************

RUN cd /tmp/scripts && sh install_node.sh

RUN echo "source /var/www/.nvm/nvm.sh" >> /var/www/.bashrc \
    # -------------------------------------------------
    && chown 33:33 /var/www/.bashrc \
    # -------------------------------------------------
    && echo "export BASH_ENV=${BASH_ENV}" >> /etc/profile



RUN chown www-data:www-data -R /var/www/scripts && \
    #make sure for the whole installation xdebug is off for performance
    sh /var/www/scripts/bin/xdebug_disable.sh && \
    chmod 755 /*.sh && \
    chown 33:33 -R /var/www/html && \
    mkdir -p /var/www/.npm && chown 33:33 /var/www/.npm -R && \
    # this is necessary so that our user can
    # change the default nvm node version
    # otherwise the persisted node version switch would not work!
    mkdir -p /var/www/.nvm && chown 33:33 /var/www/.nvm -R && \
    echo ""

## ***********************************************************************
## SWITCH TO NORMAL USER (NOT ROOT ANYMORE!)
## everything down here is now done as our www-data / dockware user
## just like you would do it manually in the container
## ***********************************************************************

USER dockware

# make the apache folder the working directory
WORKDIR /var/www/html

## ***********************************************************************
##  POST BUILD
## ***********************************************************************

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]


# TODO xdebug
# TODO tidways
#
# navigate to another folder outside shopware to avoid this error: npm ERR! Tracker "idealTree" already exists
#cd /var/www && npm install -g grunt-cli
#cd /var/www && npm install grunt --save-dev
#npm install -g --no-install-recommends yarn

# chown -R www-data:www-data /var/www/.composer