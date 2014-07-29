FROM ubuntu:14.04

RUN apt-get install nginx supervisor wget curl ruby -y

RUN gem sources -r http://rubygems.org/ && gem sources -a https://rubygems.org/
RUN gem install small-ops -v 0.0.13

RUN mkdir /var/log/supervisord
RUN echo 'daemon off ;' >> /etc/nginx/nginx.conf

ADD nginx.conf.erb /root/nginx.conf.erb
ADD supervisord.conf /etc/supervisor/conf.d/proxy.conf

EXPOSE 80

CMD [ "supervisord" ]

