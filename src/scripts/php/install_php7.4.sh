apt-get install -y  php7.4-fpm \
                    php7.4-gd \
                    php7.4-mbstring \
                    php7.4-iconv \
                    php7.4-intl \
                    php7.4-json \
                    php7.4-xml \
                    php7.4-pdo \
                    php7.4-mysql \
                    php7.4-apcu \
                    php7.4-apc \
                    php7.4-curl \
                    php7.4-cli \
                    php7.4-ldap \
                    php7.4-pgsql \
                    php7.4-gettext \
                    php7.4-zip \
                    php7.4-soap \
                    php7.4-bcmath \
                    php7.4-redis \
                    php7.4-imap \
                    php7.4-ssh2 \
                    php7.4-pcov \
                    php7.4-mongo \
                    dh-php \
                    php7.4-geoip \
                    php7.4-amqp \
                    php7.4-xdebug \
                    libpcre3 libpcre3-dev


cat /tmp/config/php/general.ini >| /etc/php/7.4/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/7.4/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/7.4/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.4/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/7.4/cli/conf.d/20-xdebug.ini