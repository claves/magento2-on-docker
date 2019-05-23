FROM php:7.1-apache

RUN apt-get update \
  && apt-get install -y \
    apt-utils \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    mysql-client \
    vim \
    wget \
    git \
    sudo \
  && docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    dom \
    gd \
    intl \
    mbstring \
    mcrypt \
    bcmath \
    pdo_mysql \
    opcache \
    xsl \
    zip \
    soap \
  && a2enmod rewrite \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && pecl install xdebug && docker-php-ext-enable xdebug \
  && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host=192.168.201.6" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=Listen for XDebug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && chmod 666 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && useradd -m -d /home/magento -s /bin/bash magento && adduser magento sudo \
  && echo "magento ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && mkdir -p /etc/sudoers.d && touch /etc/sudoers.d/privacy \
  && echo "Defaults        lecture = never" >> /etc/sudoers.d/privacy \
  && usermod -aG www-data magento \
  && usermod -aG magento www-data
ENV WEBROOT_PATH /var/www/html
RUN passwd magento -d