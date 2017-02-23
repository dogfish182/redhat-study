#!/bin/bash
#variables
OSTYPE=RedHat_64
MEMORY=1024
CPUS=1
NATNETWORK="Homey"
HOSTONLYNET="vboxnet0"
VMLIST="server1.bat.net server2.bat.net kdc.bat.net"
DISKPATH="/home/ghawker/VirtualBox VMs"
#add path to install disk to have it mounted. leave blank if not required.
INSTALLMEDIA="/home/ghawker/Software/rhel-server-7.3-x86_64-dvd.iso"

for VM in $VMLIST; do
	#skip any existing boxes based on name
	ALLBOXES=$(vboxmanage list vms | cut -d " " -f1|sed s/\"//g)
	if [[ $ALLBOXES == *"$VM"* ]]; then
		echo "$VM already exists, skipping" 
		continue
	fi
	VBoxManage createvm --name "${VM}" --register --ostype $OSTYPE
	if [ $? -ne 0 ]; then
		echo "VBox creation failed, exiting"
		exit 1
	else
		#ram and cpu additon
		VBoxManage modifyvm ${VM} --memory $MEMORY --cpus $CPUS 
	fi 
	#Natnetwork creation
	NATNET=$(VBoxManage natnetwork list | grep Name)
	if [ -z "$NATNET" ]; then 
		echo "natnetwork not found, exiting"
		exit 1
	elif [ $(echo $NATNET | cut -d: -f2) != $NATNETWORK ]; then
		echo "natnetwork name mismatch. Check virtualbox natnetwork config and name specification"
		exit1
	else
		#Nic1 addtion
		VBoxManage modifyvm ${VM} --nic1 natnetwork --nat-network1 $NATNETWORK --nictype1 82540EM --cableconnected1 on --nicspeed1 1000000
	fi

	#Host Only network creation
	HOSTNET=$(ip addr | grep $HOSTONLYNET)
	if [ -z "$HOSTNET" ]; then 
		echo "hostnetwork not found, exiting"
		exit 1
	elif [ $(echo $HOSTNET | cut -d: -f2) != $HOSTONLYNET ]; then
		echo "Check host only network name. host only network name mismatch"
		exit 1
	else
		# Nic2 Host only addition
		VBoxManage modifyvm ${VM} --nic2 hostonly --hostonlyadapter2 $HOSTONLYNET --nictype2 82540EM --cableconnected2 on --nicspeed2 1000000
	fi

	# add storage controllers
	VBoxManage storagectl ${VM} --name IDE --add ide
	VBoxManage storagectl ${VM} --name SATA --add sata

	# add some disks
	VBoxManage createmedium --filename "${DISKPATH}/${VM}/${VM}.vdi" --size 8192
	VBoxManage storageattach ${VM} --storagectl "SATA" --device 0 --port 0 --type hdd --medium "${DISKPATH}/${VM}/${VM}.vdi"
	if [ -z "$INSTALLMEDIA" ]; then
		VBoxManage storageattach ${VM} --storagectl "IDE" --device 0 --port 0 --type dvddrive
	else
		VBoxManage storageattach ${VM} --storagectl "IDE" --device 0 --port 0 --type dvddrive --medium "${INSTALLMEDIA}"
	fi

done

