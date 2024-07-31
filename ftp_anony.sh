#!/bin/bash

# Function to log in to an IP address and capture the output
login_and_capture() {
    local ip=$1
    local port=$2
    local user=$3
    local password=$4
    local output_file="${ip}_ftp.txt"

    # Use a temporary file to store the FTP commands
    tmpfile=$(mktemp)

    # Write the FTP commands to the temporary file
    cat << EOF > $tmpfile
open $ip $port
user $user $password
bye
EOF

    # Run the FTP command and capture the output
    ftp -inv < $tmpfile > $output_file

    # Check if the login was successful
    if grep -q "230" $output_file; then
        echo "Successfully logged in to $ip"
        echo "Output written to $output_file"
    else
        echo "Failed to log in to $ip"
        rm $output_file
    fi

    # Remove the temporary file
    rm $tmpfile
}

# Parse command-line arguments
while getopts "i:p:u:P:" opt; do
    case $opt in
        i) input=$OPTARG ;;
        p) port=$OPTARG ;;
        u) user=$OPTARG ;;
        P) password=$OPTARG ;;
        *) echo "Usage: $0 -i <IP address or input file> -p <port> -u <username> -P <password>" 
           exit 1 ;;
    esac
done

# Check if all required arguments are provided
if [[ -z $input || -z $port || -z $user || -z $password ]]; then
    echo "Usage: $0 -i <IP address or input file> -p <port> -u <username> -P <password>"
    exit 1
fi

# Process the input
if [[ -f $input ]]; then
    # Input is a file, iterate through each line (IP address)
    while IFS= read -r ip; do
        login_and_capture $ip $port $user $password
    done < $input
else
    # Input is a single IP address
    login_and_capture $input $port $user $password
fi

