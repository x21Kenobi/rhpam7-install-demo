# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define "jboss.vm" do |box|

      box.vm.hostname = "jboss.vm"
      box.vm.network "private_network", ip: "192.168.42.42"
      box.vm.box = "bento/centos-7"

      box.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = "2"
      end

      box.vm.provision "shell", inline: "yum install -y unzip java-1.8.0-openjdk"
      box.vm.provision "shell", path: "./init.sh"

    end
end
