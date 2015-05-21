# proxy-docker

This container proxy docker entries from registrator on consul.

## How it works

- Your run your web apps on docker containers, with names and ports
- You register these containers on consul using gliderlabs/registrator
- Proxy-docker container watches consul for these apps and proxy their names to their proper ports

## Usage

Assuming you are runing at server 192.168.50.25, whenever you see that as HOST.

Start with consul:

    $ docker run -d --name consul -v /var/run/docker.sock:/var/run/docker.sock -P progrium/consul -server -bootstrap -ui-dir /ui

Start the registrator:

    $ docker run -d --name registrator -v /var/run/docker.sock:/tmp/docker.soc -P --link consul:consul -internal consul://consul:8500

Them run a few webapps:

    $ docker run -d -P --name elasticsearch -t dockerfile/elasticsearch
    $ docker run -d -P --name blog -t tutum/wordpress

And finally start the proxy:

    $ docker run -d -p 80:80 ---link consul:consul -e ROOT_APP=blog --name proxy -t diogok/proxy-docker

And this proxy will be set:

    http://192.168.50.25/
    http://192.168.50.25/elasticsearch
    http://192.168.50.25/blog
    http://192.168.50.25/proxy 

At any change the registrator will update consul and the proxy will auto-update.

## TODO

- subdomains

## License 

MIT

