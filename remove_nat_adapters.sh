#!/bin/bash

# Check if VBoxManage is available
if ! command -v VBoxManage &> /dev/null; then
  echo "Error: VBoxManage is not in your PATH. Please add VirtualBox to your PATH and try again."
  exit 1
fi

echo "Disconnecting NAT adapter cables from all Edge VMs..."

# Disconnect the NAT adapter cable for all edge vms
VBoxManage list vms | awk -F '"' '{print $2}' | while read -r vm; do
  if [[ "$vm" == "utizmon_master_vm1" ]]; then
    echo "Skipping NAT disconnection for $vm"
    continue
  fi
  echo "Disconnecting NAT adapter cable for VM: $vm"
  VBoxManage controlvm "$vm" setlinkstate1 off
done