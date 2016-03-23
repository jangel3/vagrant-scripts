# -*- mode: ruby -*-
# vi: set ft=ruby :

$SERVER_SCRIPT = <<EOF
touch /var/log/vagrant-ipa-setup.log; \
yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;\
git clone https://github.com/jangel3/vagrant-scripts.git /vagrant/config/server_config/ | tee -a /var/log/vagrant-ipa-setup.log;\
source /vagrant/config/server_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;\
sh /vagrant/config/server_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;
EOF

$CLIENT_SCRIPT = <<EOF
touch /var/log/vagrant-ipa-setup.log; \
yum install -y git | tee -a /var/log/vagrant-ipa-setup.log;\
git clone https://github.com/jangel3/vagrant_client_scripts.git /vagrant/config/client_config/ | tee -a /var/log/vagrant-ipa-setup.log;\
source /vagrant/config/client_config/config.sh | tee -a /var/log/vagrant-ipa-setup.log;\
sh /vagrant/config/client_config/install.sh    | tee -a /var/log/vagrant-ipa-setup.log;
EOF

Vagrant.configure("2") do |config|
  config.vm.box = "jangel3/fedora_21_32bit"
  config.vm.box_url = "https://atlas.hashicorp.com/jangel3/boxes/fedora_21_32bit"

  #config.vm.provider :virtualbox do |vb|
  #  vb.gui = true
  #end
  
  #config.ssh.username = "vagrant"
  #config.ssh.password = "vagrant"

  config.vm.define :ipaserver do |ipaserver|
    ipaserver.vm.network :forwarded_port, guest: 80, host: 8080
    ipaserver.vm.network :forwarded_port, guest: 443, host: 1443
    ipaserver.vm.network :private_network, ip: "192.168.56.101"
    ipaserver.vm.hostname = "ipaserver.example.com"
    ipaserver.vm.provision :shell, :inline => $SERVER_SCRIPT
  end

  config.vm.define :client do |client|
    client.vm.network :forwarded_port, guest: 80, host: 8888
    client.vm.network :forwarded_port, guest: 443, host: 2443
    client.vm.network :private_network, ip: "192.168.56.102"
    client.vm.hostname = "client.example.com"
    client.vm.synced_folder "website/", "/var/www/website"
    client.vm.provision :shell, :inline => $CLIENT_SCRIPT
  end
end
