# Ensure VM argument is passed correctly
check_vm:
	@if [ -z "$(VM)" ]; then \
		echo "Error: VM name is required. Use 'make <target> VM=<vm_name>'"; \
		exit 1; \
	fi

# Create a specified VM
create: check_vm
	vagrant up $(VM)

# Destroy a specified VM
destroy: check_vm
	vagrant destroy -f $(VM)

# Reload a specified VM
reload: check_vm
	vagrant reload $(VM)

# SSH into a specified VM
ssh: check_vm
	vagrant ssh $(VM)

# Show the status of all VMs
status:
	vagrant status

# Create all VMs
create-all:
	vagrant up && ./remove_nat_adapters.sh

# Destroy all VMs
destroy-all:
	vagrant destroy -f

# Reload all VMs
reload-all:
	vagrant reload

# Clean up all Vagrant files
clean:
	vagrant destroy -f
	rm -rf .vagrant

run:
	vagrant ssh vm1 -c ' \
		rm -rf utizmon && \
		git clone https://github.com/Abhijeetk431/utizmon.git && \
		cd utizmon/ansible && \
		export ANSIBLE_HOST_KEY_CHECKING=False && \
		ansible-playbook -i inventory.ini playbook.yml' && \
	VM_IP=$$(vagrant ssh vm1 -c "ip -4 addr show eth2 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'" | tr -d '\r') && \
	echo 'Application should be accessible at http://'$$VM_IP':5000'
