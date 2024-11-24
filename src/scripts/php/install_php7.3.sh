apt-get install -y  php7.3-fpm \
                    php7.3-apc \
                    php7.3-apcu \
                    php7.3-curl \
                    php7.3-cli \
                    php7.3-gd \
                    php7.3-json \
                    php7.3-ldap \
                    php7.3-mysql \
                    php7.3-pgsql \
                    php7.3-gettext \
                    php7.3-intl \
                    php7.3-xml \
                    php7.3-mysql \
                    php7.3-mbstring \
                    php7.3-zip \
                    php7.3-soap \
                    php7.3-memcached \
                    php7.3-redis \
                    php7.3-bcmath \
                    php7.3-imap \
                    php7.3-ssh2 \
                    php7.3-pcov \
                    dh-php \
                    php7.3-geoip \
                    php7.3-amqp \
                    php7.3-xdebug \
                    php7.3-mongo


pecl install -2.6.1

cat /tmp/config/php/general.ini >| /etc/php/7.3/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/7.3/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/7.3/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.3/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.3/cli/conf.d/20-xdebug.ini