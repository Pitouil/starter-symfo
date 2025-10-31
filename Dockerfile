FROM php:8.4-fpm as php

ARG USER_ID=1000
ARG GROUP_ID=1000


# Install needed packages
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions zip sockets pdo_mysql intl gd && \
    rm -f /usr/local/bin/install-php-extensions

RUN apt-get update && apt-get install -y git

# Install Chromium for headless stuff
RUN apt-get update && apt-get upgrade -y && \
    apt-get install chromium -y

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony


# Set PHP limits
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory_limit.ini
RUN echo "post_max_size=64M" > /usr/local/etc/php/conf.d/post_max_size.ini
RUN echo "upload_max_filesize=64M" > /usr/local/etc/php/conf.d/upload_max_filesize.ini

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY --chmod=0755 user_entry_point.sh /user_entry_point.sh
RUN /user_entry_point.sh ${USER_ID} ${GROUP_ID}

USER ${USER_ID}:${GROUP_ID}

CMD ["php-fpm"]