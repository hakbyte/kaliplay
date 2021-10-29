# Kali Play

# Usage

Install Ansible:

```
sudo apt-get install ansible
```

Clone this repo:

```
git clone https://github.com/hakbyte/kaliplay
cd kaliplay
```

Run the `system.yml` playbook in order to configure the system:

```
ansible-playbook -i host plays/system.yml -K
```

In case Kali is inside VirtualBox:

```
ansible-playbook -i host plays/system.yml -K -e target=vbox
```
