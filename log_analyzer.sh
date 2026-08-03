#!/bin/bash

failed_logins() {

    echo
    echo "==== Failed Login Attempts ===="

    sudo lastb | head -20

}

successful_logins() {

    echo
    echo "==== Successful Logins ===="

    last | head -20

}

while true
do
    clear

    echo "========================="
    echo " Linux Log Analyzer"
    echo "========================="

    echo
    echo "1) Failed Login Attempts"
    echo "2) Successful Logins"
    echo "3) Exit"

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
            break
            ;;

       *)
            echo "Invalid Choice"
            ;;

    esac

     read -p "Press Enter..."
done
