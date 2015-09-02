# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Bring up multiple machines - see http://docs.vagrantup.com/v2/multi-machine/

  # A machine for building the .deb file
  config.vm.define "packaging" do |packaging|
    config.vm.provision "shell", path: "vagrant/bootstrap_packaging_box.sh"
  end

  # A machine for testing installation the .deb file
  config.vm.define "test" do |test|
    config.vm.provision "shell", path: "vagrant/bootstrap_test_box.sh"
    
    # Forward port 80 which Nginx listens to
    config.vm.network "forwarded_port", guest: 80, host: 8080
  end

end
