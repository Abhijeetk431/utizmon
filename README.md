# Network Architecture

This repository deploys a virtualized environment consisting of three VMs:

- **Master Node:** Collects performance metrics and hosts a web application.
- **Edge Devices (2 Nodes):** Stream performance metrics to the master node.

## Network Setup

1. **Host-Only Network:** Connects all VMs internally to facilitate metric streaming.
2. **Bridged Network:** Connects the master node to the host machine, allowing access to the web app.

The web application running on the master node processes the collected metrics and exposes them via the bridge network, making it accessible to the host machine's browser. Even though the edge devices are not directly connected to the host, their metrics are viewable via the web application.

---

# Steps to Use the Repo

### Prerequisites

- Windows OS
- Oracle VirtualBox installed
- Git installed
- Git Bash (for executing `make` commands)

### Cloning the Repository

```sh
git clone git@github.com:Abhijeetk431/utizmon.git
cd utizmon
```

### Creating Virtual Machines

To create all VMs and set up networking, SSH, and configurations:

```sh
make create-all
```

### Running the Application

Once the VMs are up, run the Ansible playbook to set up and start the web application:

```sh
make run
```

This will deploy the necessary files and services on the VMs.

### Accessing the Application

Once deployed, the web application will be available at:

```sh
http://<MASTER_VM_IP>:5000
```

You can find the exact IP by running:

```sh
vagrant ssh utizmon_master_vm1 -c "hostname -I | awk '{print $1}'"
```

### Destroying the Virtual Machines

To remove all VMs:

```sh
make destroy-all
```
