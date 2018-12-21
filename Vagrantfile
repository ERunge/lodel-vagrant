# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/debian9"

  config.vm.network "private_network", ip: "10.0.0.200"

  config.vm.synced_folder "lodel", "/var/www/lodel",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  config.vm.synced_folder "docs", "/docs"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end

  config.vm.provision :shell, :path => "shell_provisioner/install.sh"
  # config.vm.provision "file", :source => "data/dump.sql", :destination => "/var/www/lodel/dump.sql"

end
