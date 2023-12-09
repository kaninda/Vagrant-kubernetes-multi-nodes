Vagrant.configure("2") do |config|

  # Configuration globale pour toutes les machines
  config.vm.box = "ubuntu/bionic64"

  # Configuration du premier noeud
  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.hostname = "master"

    # Autoriser l'accès via SSH avec l'adresse IP
    master.vm.provision "shell", inline: <<-SHELL
      echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
    SHELL
  end

  # Configuration du deuxième noeud
  config.vm.define "node1" do |node1|
    node1.vm.network "private_network", ip: "192.168.56.11"
    node1.vm.hostname = "node1"

    # Autoriser l'accès via SSH avec l'adresse IP
    node1.vm.provision "shell", inline: <<-SHELL
      echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
    SHELL
  end

  # Configuration SSH (globale)
  config.ssh.insert_key = true
  config.ssh.forward_agent = true

end
