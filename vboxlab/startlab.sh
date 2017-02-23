for MACHINE in $(vboxmanage list vms | cut -d " " -f1|sed s/\"//g); do 
	ALLRUNNINGBOXES=$(vboxmanage list runningvms | cut -d " " -f1|sed s/\"//g)
	if [[ $ALLRUNNINGBOXES == *"$MACHINE"* ]]; then
		echo "$MACHINE already running"
	else
		vboxmanage startvm $MACHINE --type headless
	fi
done

