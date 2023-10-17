# Molecule

`ANSIBLE_COLLECTIONS_PATH=/opt/homebrew/Cellar/ansible/8.4.0/libexec/lib/python3.11/site-packages/ansible_collections/:/opt/homebrew/Cellar/ansible/8.4.0/libexec/lib/python3.11/site-packages/ansible_collections/community 
molecule test -s default_group --destroy=never`

# Testing on local VM

`ansible-playbook -b -i 192.168.64.5, playbooks/yoda_mount.yml --extra-vars "ansible_ssh_user=root" -vvv`
