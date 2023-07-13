FROM php:8.1-apache

RUN apt-get update && \
    apt-get install --yes --force-yes \
    cron g++ gettext libicu-dev openssl \
    libc-client-dev libkrb5-dev  \
    libxml2-dev libfreetype6-dev \
    libgd-dev libmcrypt-dev bzip2 \
    libbz2-dev libtidy-dev libcurl4-openssl-dev \
    libz-dev libmemcached-dev libxslt-dev git-core libpq-dev \
    libzip4 libzip-dev libwebp-dev

RUN docker-php-ext-install bcmath bz2 calendar  dba exif gettext iconv intl  soap tidy xsl sockets zip&&\
    docker-php-ext-install mysqli pgsql pdo pdo_mysql pdo_pgsql  &&\
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp &&\
    docker-php-ext-install gd &&\
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl &&\
    docker-php-ext-install imap &&\
    docker-php-ext-configure hash --with-mhash &&\
    pecl install xdebug && docker-php-ext-enable xdebug &&\
    pecl install mongodb && docker-php-ext-enable mongodb &&\
    pecl install redis && docker-php-ext-enable redis && \
    curl -sS https://getcomposer.org/installer | php \
            && mv composer.phar /usr/bin/composer

RUN a2enmod rewrite

RUN sed -i 's/memory_limit=128M/memory_limit=4G/g' /usr/local/etc/php/php.ini-production
COPY ./ /var/www/html

EXPOSE 80

ENTRYPOINT ["apache2-foreground"]

RUN chown -R root:www-data ./ && chmod -R 755 ./ && \
    php bin/magento setup:install --base-url=http://localhost --db-host=azure-db-01.mysql.database.azure.com --db-name=magento --db-user=magento --db-password=std123 --admin-firstname=azure --admin-lastname=azure --admin-email=vishwajeet-pratap@cssoftsolutions.com --admin-user=azure --admin-password=Magento@123456 


