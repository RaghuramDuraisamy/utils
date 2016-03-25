#bin/bash
#Opens predefined set of Konsole tabs, with a title for each tab, and run one or more commands on each tab
#Ref - https://gist.github.com/chetanmeh/5676141

#Pre-condition
if [ ! -d /media/raghuram/store ]; then
    echo "Drive not mounted!"
    exit
fi

function load-tabs(){
    #Create session data in format '<Number of Commands> <Tab Name/Title>   <Command-1> [<Command-2> <Command-3> ... <Command-N>]'
    local sessions=(
        2 REPO_UTILS 	 'cd /media/raghuram/store/repo/utils' 'git status'
     )
    local nsessions=0

    local session_count=${#sessions[*]}
    local i=0

    while [[ $i -lt $session_count ]]
    do
        local commandCount=${sessions[$i]}
        let i++
        local name=${sessions[$i]}
        let i++

        echo "Creating $name and will run $commandCount commands"
        local session_num=$(qdbus org.kde.konsole /Konsole newSession)
        sleep 0.1
        qdbus org.kde.konsole /Sessions/$session_num setTitle 0 $name
        sleep 0.1
        qdbus org.kde.konsole /Sessions/$session_num setTitle 1 $name
        sleep 0.1

	while [[ $commandCount -gt 0 ]]
	do
	        local command=${sessions[$i]}
	        let i++
		echo "Running command: $command"
	        qdbus org.kde.konsole /Sessions/$session_num sendText "$command"
	        sleep 0.1
	        qdbus org.kde.konsole /Sessions/$session_num sendText $'\n'
	        sleep 0.1
		let commandCount--
	done

        let nsessions++
    done

     # Activate first session.
    while [[ $nsessions -gt 1 ]]
    do
        qdbus org.kde.konsole /Konsole prevSession
        let nsessions--
    done

}

load-tabs

exit 0
