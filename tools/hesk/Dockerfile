FROM centos:7

# 安装必要的扩展和工具（php要>=5.6.0版本）
RUN yum install -y epel-release \
                   curl \
                   curl-devel \
                   unzip \
                   httpd \
                   http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum-config-manager --enable remi-php56
RUN yum install -y php \
                   php-mcrypt \
                   php-cli \
                   php-gd \
                   php-curl \
                   php-mysql \
                   php-ldap \
                   php-zip \
                   php-fileinfo \
                   php-odbc \
                   php-pear \
                   php-xml \
                   php-xmlrpc \
                   php-mbstring \
                   php-snmp \
                   php-soap \
                   php-bcmath \
                   && yum clean all \
                   && rm -rf /var/cache/yum/*

# 将HESK的代码复制到Docker镜像中
COPY hesk345.zip /tmp/
RUN unzip /tmp/hesk345.zip -d /var/www/html/hesk
COPY zh_cmn_hans.zip /tmp/
RUN unzip /tmp/zh_cmn_hans.zip -d /var/www/html/hesk/language/
RUN chmod -R 777 /var/www/html/hesk

# 设置工作目录
WORKDIR /var/www/html

# 开放必要的端口
EXPOSE 80

# 设置容器的启动命令
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
