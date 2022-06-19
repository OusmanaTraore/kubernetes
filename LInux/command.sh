#!/bin /bash

## Find 
    # files modified last 5 minutes in /dev/
    find  /dev/ -mmin -5

    # find in /var/log perm for the group with at least w and nor r or w for others
    sudo find /var/log/ -perm -g=w ! -perm /o=rw  > data.txt

    # find file with size of 213k or with permission 402 in octal
    find /home/bob -size 213k -o -perm 402 > secfile.txt
    
    #Find dogs.txt file under /usr/share directory Save the location of the file in /home/bob/dogs file.
    sudo find /usr/share -name dogs.txt  > /home/bob/dogs ; cat /home/bob/dogs

    #Find cats.txt file under /home directory .Copy it into  /opt.
    sudo find /home/bob -name cats.txt  
    cp some_file /opt/cats.txt 

    #Find all the files whose permissions are 0640 in /usr/ . save the output (along with parent path) in /home/bob/.opt/permissions.txt 
    sudo find /usr -type f -perm 0640  > .opt/permissions.txt

    #
    sudo find /var -type f -perm 0777 -print | wc -l
    
    # Find all the files which have been modified in the last 2 hours in /usr directory.
    sudo find /usr -type f -mmin -120 | wc -l
     
    #Find all the files which have been modified in the last 30 minutes in the /var directory.
    sudo find /var -type f -mmin -30 | wc -l 

    #Find all the files with size 20MB in /var directory.
    sudo find /var -type f -size 20M | wc -l 

    #Find all files between 5mb and 10mb in the /usr directory and save the output (along with parent path) in home/bob/size.txt file.
    sudo find /usr -type f -size +5M -size -10M  > /home/bob/size.txt

    
## Permissions
    # remove the write permission for the group from a file
    chmod g-w some_file

    # Add the permissions for setuid, setgid and sticky bit on /home/bob/datadir directory.
    chmod u+s,g+s,o+t /home/bob/datadir


## Sed
    # Change all values enabled to disabled in /home/bob/values.conf config file.
    sed -i 's/disabled/enabled/g' /home/bob/values.conf
    
    # Change all values enabled to disabled in /home/bob/values.conf config file from line number 500 to 2000.
    sed -i '500,2000s/disabled/enabled/g' /home/bob/values.conf

    #Replace all occurrence of string #%$2jh//238720//31223 with $2//23872031223 in /home/bob/data.txt file.
    sed -i 's|#%$2jh//238720//31223|$2//23872031223|g' /home/bob/data.txt

## Egrep

    #Filter out the lines that contain any word that starts with a capital letter and are then followed by exactly two lowercase letters in /etc/nsswitch.conf file and save the output in /home/bob/filtered1 file.
    egrep -w '[A-Z][a-z]{2}' /etc/nsswitch.conf > /home/bob/filtered1

    egrep -w '[0-9]{5}' /home/bob/textfile > /home/bob/number

    # How many numbers in /home/bob/textfile begin with a number 2, save the count in /home/bob/count file
    egrep ^2 /home/bob/textfile | wc -l > /home/bob/count ; cat count 
    grep -ic '^SECTION' testfile > /home/bob/count_lines

    # Find all lines in /home/bob/testfile file that contain string man, it must be an exact match.
    grep -w man testfile > /home/bob/man_filtered

## Tail
    # Save last 500 lines of /home/bob/textfile file in /home/bob/last file.
    tail -500 /home/bob/textfile > /home/bob/last ; cat /home/bob/last
        
  
### Tar
   #  Create a tar archive logs.tar (under bob's home) of /var/log/ directory.
    tar -cf log.tar /var/log
    sudo tar cfP logs.tar /var/log/

    # Create a compressed tar archive logs.tar.gz (under bob's home) of /var/log/ directory.
    sudo tar czfP logs.tar.gz /var/log/

    # List the content of /home/bob/logs.tar archive and save the output in /home/bob/tar_data.txt file.
    sudo tar tfP /home/bob/logs.tar > /home/bob/tar_data.txt

    # Extract the contents of /home/bob/archive.tar.gz to the /tmp directory
    sudo tar xf  /home/bob/archive.tar.gz -C /tmp

    # Execute /home/bob/script.sh script and save all normal output (except errors/warnings) in /home/bob/output_stdout.txt file.
    sudo ./script.sh > output_stdout.txt 

    # Execute /home/bob/script.sh script and save all command output (both errors/warnings and normal output) in /home/bob/output.txt file.
    sudo ./script.sh >  output.txt 2>&1

    # Execute /home/bob/script.sh script and save all errors only in /home/bob/output_errors.txt file.
    sudo ./script.sh 2>  output_errors.txt

    # Create a bzip archive under bob's home named file.txt.bz2 out of /home/bob/file.txt, but preserve the original file
    bzip2 --keep /home/bob/file.txt

    # Extract the contents of /home/bob/archive.tar.gz to the /opt director
    sudo tar xf  /home/bob/archive.tar.gz -C /opt

    # Create a file.tar archive of /home/bob/file directory under /home/bob location.
    sudo tar cfP file.tar  file

    # Create gzip archive of games.txt file , which is present under /home/bob directory
    gzip games.txt    

    # We have a /home/bob/lfcs.txt.xz file, uncompress it under /home/bob/.
    unxz lfcs.txt.xz

    # Sort the contents of /home/bob/values.conf file alphabetically and eliminate any common values, save the sorted output in /home/bob/values.sort file.
    sort /home/bob/values.conf | uniq  > /home/bob/values.sort

    # Sort again the contents of /home/bob/values.conf file alphabetically, eliminate any common values and ignore case.
    # Finally save the sorted output in /home/bob/values.sorted file.
    sort /home/bob/values.conf | uniq -i  > /home/bob/values.sorted