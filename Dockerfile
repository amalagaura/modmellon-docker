FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ADD libapache2-mod-auth-mellon_0.11.0-1_amd64.deb /tmp/libapache2-mod-auth-mellon_0.11.0-1_amd64.deb

RUN apt-get update && apt-get -y install apache2 
RUN dpkg -i /tmp/libapache2-mod-auth-mellon_0.11.0-1_amd64.deb; exit 0 
RUN apt-get install -yf && \
    rm /tmp/libapache2-mod-auth-mellon_0.11.0-1_amd64.deb && \    
    a2enmod rewrite headers proxy proxy_http proxy_wstunnel auth_mellon && \ 
    a2dissite 000-default

ADD mellon_proxy.conf /etc/apache2/sites-enabled
    
VOLUME /var/www
VOLUME /var/log/apache2
			
EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-X", "-D", "FOREGROUND"]
