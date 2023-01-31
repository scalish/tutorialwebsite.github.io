#!/bin/bash
    
# This bash script is used to backup a user's home directories to /tmp/.
# Reads from a list of directories created with following command:
# find . -maxdepth 1 -type d \( ! -iname ".*" \) |cut -c3- > <filename>
# in user home directory. It can also be created and edited by hand.
# This script is customized from scripts that appeared at:
# https://linuxconfig.org/bash-scripting-tutorial-for-beginners
# which backed up a user's entire home directory

    
function backup {
    
   
    	user=$(whoami)
    	echo $user
    	echo $1
  
  
    input=/home/$user/$1
    output=/tmp/${user}_home_${1}$(date +%Y-%m-%d_%H%M%S).tar.gz
    
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
    
    echo "########## $1 ##########"
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
filename="/home/shc/dirList.out"
echo "$filename"
 
while read line; do
	echo "Reading $line "
	backup $line
done < $filename
