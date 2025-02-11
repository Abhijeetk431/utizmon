Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine317"
  config.ssh.insert_key = false

  internal_ips = {
    "vm1" => "192.168.56.10",
    "vm2" => "192.168.56.11",
    "vm3" => "192.168.56.12"
  }

  # Common configuration for all VMs
  config.vm.provision "shell", inline: <<-'SHELL'
    # Create users and set passwords
    echo "root:root" | chpasswd
    adduser -D user && echo "user:user" | chpasswd
    
    # Configure SSH
    apk add openssh
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    rc-update add sshd
    service sshd start
  SHELL

  # Define edge VMs (vm2, vm3)
  ["vm2", "vm3"].each do |name|
    config.vm.define name do |vm|
      vm.vm.hostname = name
      vm.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
        vb.name = "utizmon_edge_" + name
      end
      vm.vm.network "private_network", ip: internal_ips[name]
      vm.vm.provision "shell", inline: <<-'SHELL'
        echo "192.168.56.10 vm1" >> /etc/hosts
        echo "192.168.56.11 vm2" >> /etc/hosts
        echo "192.168.56.12 vm3" >> /etc/hosts

        # Allow tcp on port 5000
        apk update && apk add iptables
        iptables -A OUTPUT -p tcp --sport 5000 -j ACCEPT
        rc-service iptables save

        # Add Dependencies
        apk add --no-cache gcc python3-dev py3-pip musl-dev linux-headers
        pip3 install flask flask-socketio eventlet psutil websocket-client requests
      SHELL
    end
  end

  # Define master vm1
  config.vm.define "vm1" do |vm1|
    vm1.vm.hostname = "vm1"
    vm1.vm.provider "virtualbox" do |vb|
      vb.memory = 1024   # Set RAM to 1GB
      vb.cpus = 1        # Set CPUs to 1
      vb.name = "utizmon_master_vm1"
    end
    vm1.vm.network "private_network", ip: internal_ips["vm1"]
    vm1.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: true

    # Ansible setup and SSH key distribution
    vm1.vm.provision "shell", inline: <<-'SHELL'
      # Add internal IPs to /etc/hosts
      echo "192.168.56.10 vm1" >> /etc/hosts
      echo "192.168.56.11 vm2" >> /etc/hosts
      echo "192.168.56.12 vm3" >> /etc/hosts

      # Install Ansible and dependencies
      apk add python3-dev py3-pip sshpass gcc libffi-dev openssl-dev musl-dev make rust cargo linux-headers git
      pip3 install ansible flask flask-socketio eventlet psutil websocket-client requests

      # Generate SSH keys
      mkdir -p /root/.ssh
      ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
      
      # Install keys on other nodes
      for node in vm2 vm3; do
        sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no root@$node
      done

      # Allow tcp on port 5000
      apk update && apk add iptables
      iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
      iptables -A OUTPUT -p tcp --sport 5000 -j ACCEPT
      rc-service iptables save
    SHELL
  end
end