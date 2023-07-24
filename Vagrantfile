# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #master
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "ubuntu/focal64"
    kmaster.vm.hostname= "kmaster"
    kmaster.vm.box_url= "ubuntu/focal64"
    kmaster.vm.network :private_network, ip: "192.168.56.100"
    kmaster.vm.synced_folder "./data", "/vagrant_data"
    kmaster.vm.provider :virtualbox do |vb|
      vb.name = "kmaster"
      vb.cpus = 2
      vb.gui = false
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    kmaster.vm.provision "shell", inline: <<-SHELL
    sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
    service ssh restart
    apt install net-tools
    SHELL
    kmaster.vm.provision "shell", path: "install_common.sh"
    kmaster.vm.provision "shell", path: "install_master.sh"
  end
  numberSrv=2
  #slave server
  (1..numberSrv).each do |i|
    config.vm.define "knode#{i}" do |knode|
      knode.vm.box = "ubuntu/focal64"
      knode.vm.hostname= "knode#{i}"
      knode.vm.network "private_network", ip: "192.168.56.11#{i}"
      knode.vm.synced_folder "./data0#{i}", "/vagrant_data"
      knode.vm.provider "virtualbox" do |v|
        v.name = "knode#{i}"
        v.cpus = 1
        v.gui = false
        v.memory = "2048"
      end
      knode.vm.provision "shell", run: "always", inline: <<-SHELL
        echo "activion ssh par adresse slave server#{i}"
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
        service ssh restart
        export DEBIAN_FRONTEND=noninteractive
        apt install net-tools
        echo " end ssh activion"
        echo "HELLO from  slave server#{i}"
      SHELL
      knode.vm.provision "shell", path: "install_common.sh"
      knode.vm.provision "shell", path: "install_nodes.sh"
    end  
  end 
end
