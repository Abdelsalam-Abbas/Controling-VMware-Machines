if [[ $1 = 'start' ]]; then
	# test if server1 is already running .. else starting it
	echo "| starting Server1...Please Wait"
	if [[ $(vmrun list | grep "/media/abbas/267ED19115D1A6AF/Machines/CentOS 64-bit/CentOS 64-bit.vmx") ]] ; then
		echo "| Server1 is already running.. Trying to Connect to Server1"
	else
		vmrun start /media/abbas/267ED19115D1A6AF/Machines/CentOS\ 64-bit/CentOS\ 64-bit.vmx nogui 2>/dev/null
	fi 
	echo -n "| Connecting to Server1 "
	# testing ssh connectivity to the server and waiting till being connected"
	while [[ True ]]; do
	    ssh server1 2>/dev/null & 
	    echo -n "."
	    sleep 1;
	    # exit script if connected 
	    if [[ $(ss -t | grep '192.168.227.150:ssh') ]]; then
		echo "Connected!"
		exit 0;
	    fi
	done
elif [[ $1 = 'stop' ]]; then

	echo "| Stopping Server1...Please Wait"
	vmrun stop /media/abbas/267ED19115D1A6AF/Machines/CentOS\ 64-bit/CentOS\ 64-bit.vmx soft 
	while [[ $(vmrun list | grep "/media/abbas/267ED19115D1A6AF/Machines/CentOS 64-bit/CentOS 64-bit.vmx") ]] ; do
		sleep 1;	
	done
	echo "| Stopped Server1...GoodBye!"
fi

