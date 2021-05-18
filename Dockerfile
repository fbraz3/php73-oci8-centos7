FROM centos:7

RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="rh-php73 rh-php73-php rh-php73-php-fpm rh-php73-php-mysqlnd rh-php73-php-pgsql rh-php73-php-bcmath \
                  rh-php73-php-gd rh-php73-php-intl rh-php73-php-ldap rh-php73-php-mbstring rh-php73-php-pdo \
                  rh-php73-php-process rh-php73-php-soap rh-php73-php-opcache rh-php73-php-xml \
                  rh-php73-php-gmp rh-php73-php-pecl-apcu rh-php73-php-devel httpd24-mod_ssl mlocate" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

RUN ln -s /opt/rh/rh-php73/root/usr/bin/* /usr/bin/ && \
    ln -s /opt/rh/rh-php73/root/usr/sbin/* /usr/sbin/ && \
    ln -s /etc/opt/rh/rh-php73 /etc/php

RUN ln -s /opt/rh/httpd24/root/etc/httpd /etc/ && \
    ln -s /opt/rh/httpd24/root/usr/bin/* /usr/bin/ && \
    ln -s /opt/rh/httpd24/root/usr/sbin/* /usr/sbin/ && \
    sed -i '/http2_module/d' /opt/rh/httpd24/root/etc/httpd/conf.modules.d/00-base.conf

COPY resources/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm /tmp
COPY resources/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm /tmp

RUN yum -y install /tmp/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm && \
    yum -y install /tmp/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm

RUN printf "\n" | pecl install oci8-2.2.0

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh

#Clean Packages
RUN rm -rf /tmp/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm && \
    rm -rf /tmp/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm

ENTRYPOINT /entrypoint.sh