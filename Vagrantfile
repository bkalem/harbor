Vagrant.configure("2") do |config|

  config.vm.define "harbor" do |harbor|
    harbor.vm.box = "centos/7"
    harbor.vm.hostname = "registry.formini.local"
    harbor.vm.network "private_network", ip: "172.15.20.99"
    harbor.vm.provider "virtualbox" do |v|
      v.name = "harbor"
      v.cpus = 2
      v.memory = 4096
    end
    harbor.vm.provision "shell", path: "install-docker.sh"
    harbor.vm.provision "shell", path: "install-docker-compose.sh"
    harbor.vm.provision "shell", path: "install-vmware-harbor.sh"
    harbor.vm.provision "shell", path: "custom-linux.sh"
  end

  config.vm.define "worker" do |worker|
    worker.vm.box = "centos/7"
    worker.vm.hostname = "worker.formini.local"
    worker.vm.network "private_network", ip: "172.15.20.199"
    worker.vm.provider "virtualbox" do |v|
      v.name = "worker"
      v.cpus = 1
      v.memory = 1024
    end
    worker.vm.provision "shell", path: "install-docker.sh"
    worker.vm.provision "shell", path: "custom-linux.sh"
    worker.vm.provision "shell", path: "connect-to-registry.sh"
  end

end