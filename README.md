# Utizmon Virtualized Monitoring System

## Network Architecture

This repository deploys a virtualized monitoring system consisting of multiple VMs on a Windows host using Vagrant and VirtualBox. The architecture consists of:

- **Master Node (utizmon_master_vm1)**:

  - Collects performance metrics from edge devices.
  - Hosts a web application that displays the performance data.
  - The web application is exposed to the host machine using a **bridged network**, allowing the host browser to access it.

- **Edge Devices (utizmon_edge_vm2 & utizmon_edge_vm3)**:
  - Stream performance metrics to the master node over a **host-only network**.
  - Do not have a direct network connection with the host machine.

This setup ensures that the host machine can access the web application on the master node while keeping the edge devices isolated from the host.

## Prerequisites

Before using this repository, ensure that the following dependencies are installed on your Windows machine:

- [Oracle VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Git](https://git-scm.com/)

## Steps to Use the Repository

1. **Clone the repository**  
   Open Git Bash and run:
   ```sh
   git clone git@github.com:Abhijeetk431/utizmon.git
   cd utizmon
   ```
