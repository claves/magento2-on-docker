FROM php:8.2-apache

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
  && pecl install xdebug && docker-php-ext-enable xdebug \
  && pecl install imagick && docker-php-ext-enable imagick \
  && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.discover_client_host=false" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && chmod 666 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
  && sed -ri 's/^(memory_limit = )[0-9]+(M|G)$/memory_limit = 2G/' /usr/local/etc/php/php.ini \
  && groupadd -g 1234 magento \
  && useradd -m -u 1234 -g magento -d /home/magento -s /bin/bash magento && adduser magento sudo \
  && echo "magento ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && mkdir -p /etc/sudoers.d && touch /etc/sudoers.d/privacy \
  && echo "Defaults        lecture = never" >> /etc/sudoers.d/privacy \
  && usermod -aG www-data magento \
  && usermod -aG magento www-data
ENV APACHE_DOCUMENT_ROOT /var/www/html/magento2/pub
RUN echo $APACHE_DOCUMENT_ROOT
RUN sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf
RUN sed -ri -e "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
WORKDIR ${DESTINATION_PATH}
RUN passwd magento -d
RUN echo elasticsearch/ca/ca.crt >> /etc/ca-certificates.conf

RUN apt-get install -y locales
RUN echo "ja_JP UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8
ENV LESS -iRMXS
ENV LESSCHARSET utf-8

COPY ./entrypoint.sh /usr/local/bin
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]
ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
