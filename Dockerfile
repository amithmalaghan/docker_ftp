from centos:7
RUN yum install -y epel-release
RUN yum install -y httpd
RUN yum install -y php
RUN yum install -y phpmyadmin
RUN yum install -y wget unzip
RUN wget https://www.net2ftp.com/download/net2ftp_v1.3.zip
RUN unzip net2ftp_v1.3.zip
RUN mkdir /var/www/html/ftp
RUN mv net2ftp_v1.3/files_to_upload/* /var/www/html/ftp
RUN chmod 777 /var/www/html/ftp/temp
RUN yum install -y proftpd-mysql
RUN yum install -y nano ftp
RUN sed -i -e '17d' -e '18d' /etc/httpd/conf.d/phpMyAdmin.conf
RUN sed -i '16 a Require all granted' /etc/httpd/conf.d//phpMyAdmin.conf
RUN sed -i "s/\$cfg\['Servers'\]\[\$i\]\['host'\]          = 'localhost'/\$cfg\['Servers'\]\[\$i\]\['host'\]      = '172.17.0.3'/" etc/phpMyAdmin/config.inc.php
RUN sed -i "s/\$cfg\['Servers'\]\[\$i\]\['port'\]          = ''/\$cfg\['Servers'\]\[\$i\]\['port'\]          = ''/" etc/phpMyAdmin/config.inc.php
RUN sed -i "s/\$cfg\['Servers'\]\[\$i\]\['user'\]          = ''/\$cfg\['Servers'\]\[\$i\]\['user'\]          = 'ftpd'/" etc/phpMyAdmin/config.inc.php
RUN sed -i "s/\$cfg\['Servers'\]\[\$i\]\['password'\]      = ''/\$cfg\['Servers'\]\[\$i\]\['password'\]      = 'amit'/" etc/phpMyAdmin/config.inc.php
COPY sql.conf /etc/
RUN  rm /etc/proftpd.conf
COPY proftpd.conf /etc/
CMD /usr/sbin/httpd && proftpd --nodaemon 
expose 80
