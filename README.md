# redhat-study

The purpose of this repo is to store things that make studying for the redhat certs easier. Initially created to store things like kickstart files for quickly setting up local labs for simulating exams etc. 

kickstart files contain unencrypted passwords that are NOT used in secure environments and just an easy place to store lab files. should N E V E R be used in a production setting. 

Generally to study for the RCHE and RHCSA you will need 3 systems. 

Server1
Server2 (probably called desktop or client in exam land, but doesn't matter really) 
Kerberos Server (the exam doesn't test the creation of, but you need keytabs for exercises). 

installs are intentionally sparse. Part of the redhat exams are knowing what packages to install therefore kickstart installs nothing extra so these can be used to drill package installs among other things.

# VBOX lab
virtual box lab has the following logic 

all systems will have 2 NICS (static configs) primary system nic will be configured in a 'NAT Network' in virtualbox terminology
secondary nic will be 'host only networking'. 

Host system can then communicate via ssh etc to the Vbox guest. All vbox guests can address the host and the outside world via the natnetwork. 

Systems are static configured in the following way

server1.bat.net 
(nat network) NIC 1:  172.18.0.200/24 gw=172.18.0.1 dns=8.8.8.8,8.8.4.4

(host only)   NIC 2:  192.168.56.200/24 

server2.bat.net
(nat network) NIC 1:  172.18.0.201/24 gw=172.18.0.1 dns=8.8.8.8,8.8.4.4

(host only)   NIC 2:  192.168.56.201/24

kdc.bat.net
(nat network) NIC 1:  172.18.0.202/24 gw=172.18.0.1 dns=8.8.8.8,8.8.4.4

(host only)   NIC 2:  192.168.56.201/24

to serve the kickstart configs install a basic apache webhost on your host machine. by default with your firewall on, the webserver will be available on your main nic for the guests. other machines on the network will not be able to reach your webserver due to the firewall. 

# Install hosts in vbox 
ensure the boxes are created with 2 nics 1 on nat network and 1 on host only. turn off dhcp for both. boot the systems from CD, push tab and enter ks=192.x.x.x/server1-ks.cfg at the end of the line to pick up the config and run it. system will install and reboot and you should have a system you can ssh to from host


