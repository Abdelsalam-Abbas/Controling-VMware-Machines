#!/bin/bash
function configure {
	# taking configuration from the user
	echo "| It seems you need to configure your Workstation setting"
        echo -n "| Vmx_Path:"	
	read Vmx_Path
        echo -n "| Machine_IP:"	
	read Machine_IP
        echo -n "| Machine_Name:"	
	read Machine_Name
	# saving values
	sed -i "s|Vmx_Path=\"\"|Vmx_Path=\"${Vmx_Path}\"|" machine.conf 
	sed -i "s|Machine_IP=\"\"|Machine_IP=\"${Machine_IP}\"|" machine.conf 
	sed -i "s|Machine_Name=\"\"|Machine_Name=\"${Machine_Name}\"|" machine.conf 
	echo "| This is Your Configuration:-"
	tail -3 machine.conf
	echo -n "| Is this OK?(Y)es, (N)o:"
	read x
	if [[ $x = 'n' || $x = 'N' ]]; then
		configure	
	fi 

}
cmd=$1

### sourcing Machine Configuration
. ./machine.conf
while [[ -z ${Machine_IP} || -z ${Machine_IP} || -z ${Vmx_Path} ]]; do
	configure
	echo "| Script is Configure , Now Run it again \"vm-control start\""
done
#saving configration 

if [[ $cmd = 'start' ]]; then
	echo "| starting ${Machine_Name}...Please Wait"
	# test if server1 is already running .. else starting it
	if [[ $(vmrun list | grep "${Vmx_Path}") ]] ; then
		echo "| ${Machine_Name} is already running.. Trying to Connect to Server1" else
	else 
		vmrun start "${Vmx_Path}" nogui 
	fi 
	echo -n "| Connecting to ${Machine_Name} "
	# testing ssh connectivity to the server and waiting till being connected"
	while [[ True ]]; do
	    ssh ${Machine_IP} 2>/dev/null  && sleep 5
	    sleep 2 
	    # exit script if connected 
	    if [[ $? = 0 ]]; then
		exit ;
	    fi
	    echo -n "."
	done
elif [[ $cmd = 'stop' ]]; then

	echo "| Stopping ${Machine_Name}...Please Wait"
	vmrun stop "${Vmx_Path}" soft 
	while [[ $(vmrun list | grep "${Vmx_Path}") ]] ; do
		sleep 10;	
		vmrun stop "${Vmx_Path}" hard 2>/dev/null 
	done
	echo "| Stopped Server1...GoodBye!"

elif [[ $cmd = 'reset' ]]; then
	sed -i "s|\".*\"|\"\"|" machine.conf

elif [[ $cmd = 'conf' ]]; then
	configure
	
else
	echo "| Usage: vm-control start|stop|conf|reset"

fi


