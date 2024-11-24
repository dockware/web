apt-get install -y  php8.3-fpm \
                    php8.3-gd \
                    php8.3-iconv \
                    php8.3-intl \
                    php8.3-xml \
                    php8.3-mbstring \
                    php8.3-pdo \
                    php8.3-mysql \
                    php8.3-curl \
                    php8.3-cli \
                    php8.3-ldap \
                    php8.3-pgsql \
                    php8.3-gettext \
                    php8.3-zip \
                    php8.3-soap \
                    php8.3-bcmath \
                    php8.3-imap \
                    php8.3-xdebug \
                    php8.3-redis \
                    php8.3-amqp \
                    php8.3-apcu \
                    php8.3-pcov \
                    php8.3-mongo \
                    dh-php

pecl install xdebug

cat /tmp/config/php/general.ini >| /etc/php/8.3/fpm/conf.d/01-general.ini
cat /tmp/config/php/general.ini >| /etc/php/8.3/cli/conf.d/01-general.ini

cat /tmp/config/php/cli.ini >| /etc/php/8.3/cli/conf.d/01-general-cli.ini

cp /tmp/conifg/php/xdebug-3.ini /etc/php/8.3/fpm/conf.d/20-xdebug.ini
cp /tmp/conifg/php/xdebug-3.ini /etc/php/8.3/cli/conf.d/20-xdebug.ini