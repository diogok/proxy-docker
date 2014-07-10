# -*- mode: ruby -*-
# vi: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.network "private_network", ip: "192.168.50.25"

  config.vm.provision "docker" do |d|
    d.run "coreos/etcd", name: "etcd", args: "-p 4001:4001 -p 7001:7001"
    d.run "coreos/etcd", name: "etcd2", args: "-p 4001:4001 -p 7001:7001"
  end

  config.vm.provision :shell, :inline => "apt-get install nginx wget curl vim -y"
  config.vm.provision :shell, :inline => "gem install small-ops --pre && docker2etcd --host 192.168.50.25"
end

