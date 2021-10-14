FROM php:7.4-apache

RUN apt-get update \
  && apt-get install -y \
    apt-utils \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    libonig-dev \
    libpng-dev \
    libmagickwand-dev \
    default-mysql-client \
    vim \
    wget \
    git \
    nodejs \
    npm \
    unzip \
  && docker-php-ext-configure \
    gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install \
    dom \
    gd \
    intl \
    bcmath \
    pdo_mysql \
    opcache \
    xsl \
    zip \
    soap \
    sockets \
  && a2enmod rewrite \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && curl https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && pecl install xdebug && docker-php-ext-enable xdebug \
  && pecl install imagick && docker-php-ext-enable imagick \
  && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && chmod 666 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
  && sed -ri 's/^(memory_limit = )[0-9]+(M|G)$/memory_limit = 2G/' /usr/local/etc/php/php.ini \
  && useradd -m -d /home/magento -s /bin/bash magento && adduser magento sudo \
  && echo "magento ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && mkdir -p /etc/sudoers.d && touch /etc/sudoers.d/privacy \
  && echo "Defaults        lecture = never" >> /etc/sudoers.d/privacy \
  && usermod -aG www-data magento \
  && usermod -aG magento www-data
ENV WEBROOT_PATH /var/www/html
RUN passwd magento -d