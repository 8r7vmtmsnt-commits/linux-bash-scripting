#!/bin/bash

failed_logins() {

    echo
    echo "==== Failed Login Summary ===="

    count=$(sudo lastb | wc -l)
    echo "Total Failed Login Attempts: $count"
    sudo lastb | head -20

}

successful_logins() {

    echo
    echo "==== Successful Login Summary ===="

    last | head -20

}

search_user() {

    read -p "Enter username to search: " username
    echo
    echo "==== Login Summary for $username ===="

    sudo last | grep "$username" | head -20

    if [ -z "$username" ]; then
        echo "No records found for user: $username"
    fi

}

search_ip() {

    read -p "Enter IP address to search: " ip_address
    echo
    echo "==== Login Summary for IP $ip_address ===="

    sudo last | grep "$ip_address" | head -20

    if [ -z "$ip_address" ]; then
        echo "No records found for IP: $ip_address"
    fi

}

export_report() {

    timestamp=$(date +%Y%m%d_%H%M%S)

    report="login_report_$timestamp.txt"

    {
        echo "==== Failed Login Summary ===="
        sudo lastb | head -20
        echo
        echo "==== Successful Login Summary ===="
        last | head -20
    } > "$report"
    echo "Report exported to $report"
}
while true
do
    clear

    echo "========================="
    echo " Linux Log Analyzer"
    echo "========================="

    echo
    echo "1) Failed Login Summary"
    echo "2) Successful Login Summary"
    echo "3) Search User"
    echo "4) Search IP"
    echo "5) Export Report"
    echo "6) Exit"

    echo
    read -p "Choose: " choice

    case $choice in

        1)
            failed_logins
            ;;

        2)
            successful_logins
            ;;

        3)
            search_user
            ;;

        4)
            search_ip
            ;;

        5)
            export_report
            ;;

        6)
            break
            ;;

       *)
            echo "Invalid Choice"
            ;;

    esac

     read -p "Press Enter..."
done
