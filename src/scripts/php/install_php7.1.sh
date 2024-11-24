apt-get install -y  php7.1-fpm \
                    php7.1-apc \
                    php7.1-apcu \
                    php7.1-curl \
                    php7.1-cli \
                    php7.1-gd \
                    php7.1-json \
                    php7.1-ldap \
                    php7.1-mysql \
                    php7.1-pgsql \
                    php7.1-gettext \
                    php7.1-intl \
                    php7.1-xml \
                    php7.1-mysql \
                    php7.1-mbstring \
                    php7.1-zip \
                    php7.1-soap \
                    php7.1-memcached \
                    php7.1-redis \
                    php7.1-bcmath \
                    php7.1-imap \
                    php7.1-ssh2 \
                    php7.1-pcov \
                    dh-php \
                    php7.1-geoip \
                    php7.1-amqp \
                    php7.1-xdebug \
                    php7.1-mongo


cat /tmp/config/php/general.ini >| /etc/php/7.1/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/7.1/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/7.1/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.1/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.1/cli/conf.d/20-xdebug.ini