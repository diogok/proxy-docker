# proxy-docker

It is a docker->etcd->nginx container, using [small-ops](http://github.com/diogok/small-ops) tools.

## How it works

- Your run your web apps on docker containers, with names and ports
- You register these containers on etcd using small-ops docker2etcd
- Proxy-docker container watches etcd for these apps and proxy their names to their proper ports

## Usage

Assuming you are runing at server 192.168.50.25, whenever you see that as HOST.

Start with etcd:

    docker run -d -p 4001:4001 -t coreos/etcd

Them run a few webapps, and the proxy:

    docker run -d -P --name elasticsearch -t dockerfile/elasticsearch
    docker run -d -P --name blog -t tutum/wordpress
    docker run -d -p 80:80 -e HOST=192.168.50.25 --name proxy -t diogok/proxy-docker

Them register them (with small-ops):

    docker2etcd

And this proxy will be set:

    http://192.168.50.25/elasticsearch
    http://192.168.50.25/blog
    http://192.168.50.25/proxy 

At any change you just need to register again so the proxy updates.

## TODO

- define root app
- subdomains

## License 

MIT

