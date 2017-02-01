FROM php:7.0-apache

RUN apt-get update && apt-get install -y libxml2-dev libcurl4-gnutls-dev libpng-dev git zip
RUN docker-php-ext-install pdo pdo_mysql mbstring bcmath curl
RUN docker-php-ext-configure gd --with-libxml-dir=/usr/include/ &&  docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-configure xml --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    &&  docker-php-ext-install -j$(nproc) xml

WORKDIR /var/www/html/

RUN curl -Lo v0.5.6.tar.gz https://github.com/Pterodactyl/Panel/archive/v0.5.6.tar.gz
RUN tar --strip-components=1 -xzvf v0.5.6.tar.gz && rm v0.5.6.tar.gz
RUN chmod -R 777 storage/* bootstrap/cache
RUN chown -R www-data:www-data *

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer setup

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN rm /etc/apache2/sites-available/*
RUN a2enmod rewrite
COPY pterodactyl.conf /etc/apache2/sites-available/000-default.conf

VOLUME ["/var/www/html/var", "/var/www/html/storage/"]

ENTRYPOINT ["./entrypoint.sh"]