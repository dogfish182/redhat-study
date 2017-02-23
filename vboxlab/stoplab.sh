for MACHINE in $(vboxmanage list runningvms | cut -d " " -f1|sed s/\"//g); do 
	vboxmanage controlvm $MACHINE acpipowerbutton
done

