
Vagrant.configure("2") do |config|
  #master
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "ubuntu/focal64"
    kmaster.vm.hostname= "kmaster"
    kmaster.vm.box_url= "ubuntu/focal64"
    kmaster.vm.network "private_network", ip: "192.168.33.10"
    kmaster.vm.synced_folder "./data", "/vagrant_data"
    kmaster.vm.provider " " do |vb|
      vb.name = "kmaster"
      vb.cpus = 2
      vb.gui = false
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    kmaster.vm.provision "shell", run: "always", inline: <<-SHELL
      echo "activion ssh par adresse"
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
      echo " end ssh activion"
      echo "HELLO from Vagrantfile"
    SHELL
  end
end
