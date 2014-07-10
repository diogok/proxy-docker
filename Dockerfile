FROM ubuntu:14.04

RUN apt-get install nginx supervisor wget curl ruby -y

RUN gem install small-ops

RUN mkdir /var/log/supervisord
RUN echo 'daemon off ;' >> /etc/nginx/nginx.conf

ADD nginx.conf.erb /root/nginx.conf.erb
ADD supervisord.conf /etc/supervisor/conf.d/proxy.conf

EXPOSE 80

CMD [ "supervisord" ]
