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
<<<<<<< HEAD
    libmagickwand-dev \
    phantomjs \
    default-mysql-client \
    vim \
    wget \
    git \
    nodejs \
    npm \
=======
    default-mysql-client \
    vim \
    wget \
    sudo \
    zsh \
    git \
    tree \
>>>>>>> noah-dev-branch
  && docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    bcmath \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    opcache \
    xsl \
    zip \
    soap \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && a2enmod rewrite \
<<<<<<< HEAD
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1 \
  && pecl install xdebug-2.9.8 && docker-php-ext-enable xdebug \
  && pecl install imagick && docker-php-ext-enable imagick \
  && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host=10.254.254.254" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
=======
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.19 \
  && pecl install xdebug-2.9.8 && docker-php-ext-enable xdebug \
  && echo "xdebug.remote_enable=1"                  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9001"                 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=0"            >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=Listen for XDebug"         >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level=1000"           >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_autostart=1"               >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
>>>>>>> noah-dev-branch
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
