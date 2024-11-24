apt-get install -y  php7.2-fpm \
                    php7.2-apc \
                    php7.2-apcu \
                    php7.2-curl \
                    php7.2-cli \
                    php7.2-gd \
                    php7.2-json \
                    php7.2-ldap \
                    php7.2-mysql \
                    php7.2-pgsql \
                    php7.2-gettext \
                    php7.2-intl \
                    php7.2-xml \
                    php7.2-mysql \
                    php7.2-mbstring \
                    php7.2-zip \
                    php7.2-soap \
                    php7.2-memcached \
                    php7.2-redis \
                    php7.2-bcmath \
                    php7.2-imap \
                    php7.2-ssh2 \
                    php7.2-pcov \
                    dh-php \
                    php7.2-geoip \
                    php7.2-amqp \
                    php7.2-xdebug \
                    php7.2-mongo


pecl install -2.6.1

cat /tmp/config/php/general.ini >| /etc/php/7.2/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/7.2/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/7.2/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.2/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.2/cli/conf.d/20-xdebug.ini