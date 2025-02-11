# **UTIZMON - CPU and Memory Utilization Monitoring System**

## **1. Introduction**

This project provides a fully automated setup for deploying a monitoring system using Vagrant, Ansible, and a WebSocket-based Python application. It provisions multiple virtual machines (VMs) to simulate a distributed environment where edge devices send CPU and memory usage metrics to a master node. The master node collects this data and displays it through a web-based dashboard accessible from the host machine.

### **Objectives**

- Automate VM creation, configuration, and deployment.
- Use WebSockets to enable real-time performance monitoring.
- Simplify deployment with Vagrant and Ansible.
- Provide an easily accessible web interface to view system metrics.

---

## **2. System Architecture**

### **VM Deployment Architecture**

- **Master VM:** Runs the web application and receives system metrics from edge devices.
- **Edge VMs (VM2, VM3):** Continuously monitor CPU and memory usage and send data to the master.
- **Networking Setup:**
  - **Host-Only Network:** Allows communication between VMs.
  - **Bridged Network:** Exposes the web application to the host machine.

### **Monitoring & Data Flow**

1. Edge VMs collect CPU and memory usage statistics.
2. Data is streamed to the master VM using WebSockets over Host Only Network.
3. The master VM runs a Flask-based web server displaying real-time metrics.
4. The host machine can access the web interface over port 5000.

---

## **3. Implementation Details**

### **Vagrant Setup**

The `Vagrantfile` defines:

- Three VMs (one master, two edge devices).
- Network configurations.
- Provisioning using shell scripts to install dependencies.

### **Ansible Playbook**

The Ansible playbook automates:

- Creation of necessary directories.
- Copying required files (`server.py`, `app.py`, `templates/`).
- Running the monitoring application as a background process.

### **Application Design**

- **`server.py`**: Runs on the master VM and receives WebSocket connections.
- **`app.py`**: Runs on edge VMs and sends system metrics.
- **WebSockets**: Enable real-time bidirectional communication between the master and edges.

---

## **4. Deployment & Usage**

### **Prerequisites**

- Windows OS.
- **Git Bash** (for executing commands).
- **Oracle VirtualBox** and **Vagrant** installed.

### **Installation & Setup**

1. Clone the repository:
   ```sh
   git clone git@github.com:Abhijeetk431/utizmon.git
   cd utizmon
   ```
2. Create and configure all VMs:
   ```sh
   make create-all
   ```
3. Deploy the application:
   ```sh
   make run
   ```
4. Find the application IP from output of above command and access it in the browser

### **Stopping & Cleaning Up**

- To destroy all VMs:
  ```sh
  make destroy-all
  ```

---

## **5. Troubleshooting & Debugging**

### **Common Issues**

- **VMs fail to start** → Ensure VirtualBox and Vagrant are installed correctly.
- **Playbook fails due to SSH issues** → Add the host to `known_hosts`.
- **Web app is unreachable** → Verify networking settings and firewall rules.

### **Checking VM & Application Status**

- To verify running VMs:
  ```sh
  vagrant status
  ```
- To check application logs:
  ```sh
  vagrant ssh utizmon_master_vm1 -c "cat /app/server.log"
  ```

---

## **6. Future Enhancements & Scalability**

- Add database support to persist monitoring data.
- Enable monitoring for additional performance metrics (disk usage, network traffic, etc.).
- Deploy on a cloud-based environment for scalability.

---

## **7. Conclusion**

This system provides a simple yet effective way to monitor VM performance using WebSockets and Flask. By leveraging Vagrant and Ansible, deployment is fully automated, making it easy to set up, manage, and scale. The architecture ensures efficient communication between master and edge devices, offering a robust solution for real-time monitoring.

---
