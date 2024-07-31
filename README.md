# ftp_anony - Written by ChatGPT
A bash script to check for anonymous FTP and gather evidence of connection.
Example:
You are on a penetration test and identify a bunch of FTP services. You can use this script to try anonymously logging in to them. If the script detects a 230 status code it then captures all of the connectivity evidence and outputs it into a txt file. The script displays in stdout whether it was sucessful in connecting to the FTP service anonymously. 

Usage:
./ftp_anony.sh -i <INPUT FILE_OR IP> -p <PORT> -u <USERNAME> -P <PASSWORD>
