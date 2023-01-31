#!/bin/bash
    
# This bash script is used to backup a user's  directory to /tmp/.
# It is invoked with a list of the desired direcories to be backed up preceeded by the user directory name
# ie: ./backup5.sh user Documents Pictures
# It was adapted from scripts originally found at: 
# https://linuxconfig.org/bash-scripting-tutorial-for-beginners
    
function backup {
    
 # assume script is run from user directory to be backed up
    
	
    	
    	
# check that /home/$user/directory exists if not exit with error mesage
#  -d checks that file exists and is a directory. See man bash conditional expressions

if [ ! -d "/home/$user/$1" ]; then
		echo "Requested $directory directory doesn't exist."
		exit 1
fi

 
        
    
    input=/home/$user/$1
    output=/tmp/${user}_home_${1}$(date +%Y-%m-%d_%H%M%S).tar.gz
    
    
#

 
    function total_files {
    	find $1 -type f | wc -l
    }
    
    function total_directories {
    	find $1 -type d | wc -l
    }
    
    function total_archived_directories {
    	tar -tzf $1 | grep  /$ | wc -l
    }
    
    function total_archived_files {
    	tar -tzf $1 | grep -v /$ | wc -l
    }
    
    tar -czf $output $input 2> /dev/null
    
    src_files=$( total_files $input )
    src_directories=$( total_directories $input )
    
    arch_files=$( total_archived_files $output )
    arch_directories=$( total_archived_directories $output )
    
    echo "########## $user/$1 ##########"
    echo "Files to be included: $src_files"
    echo "Directories to be included: $src_directories"
    echo "Files archived: $arch_files"
    echo "Directories archived: $arch_directories"
    
    if [ $src_files -eq $arch_files ]; then
    	echo "Backup of $input completed!"
    	echo "Details about the output backup file:"
    	ls -l $output
    else
    	echo "Backup of $input failed!"
    fi
}
args=$#
echo "number of args= $args"
user=$1
echo $user
shift 1 
for directory in $*; do 
    echo "Backing up /home/$user/$directory"
    backup $directory 
done;
