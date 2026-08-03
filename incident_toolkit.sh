#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG_DIR="$HOME/incident_logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/toolkit.log"

log_action() {

    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"

}

log_action "viewed system information"
system_info() {

    echo
    echo "===== System Information ====="

    echo "Hostname: $(hostname)"
    echo "Current User: $(whoami)"
    echo "Kernel Version: $(uname -r)"
    echo "Current Time: $(date)"
    echo "System Uptime: $(uptime)"
}

log_action "viewed process information"
process_info() {

    echo
    echo "===== Top processes ====="

    ps aux --sort=-%cpu | head

}

log_action "viewed network information" 
network_info() {

    echo
    echo "===== Network Connections ====="

    ss -tuln

}

log_action "viewed login information"
logged_in_users() {

    echo
    echo "===== Logged-in Users ====="

    who

}

log_action "viewed disk usage information"
disk_usage() {

    echo
    echo "===== Disk Usage ====="

    df -h

}

log_action "viewed memory information"
memory_info() {

    echo
    echo "===== memory info ====="

    free -h

}

log_action "viewed memory information"
recent_logins() {

    echo
    echo "===== Recent Logins ====="

    last | head -10

}

log_action "viewed failed logins"
failed_logins() {

    echo
    echo "===== Failed login Attempts ====="

    sudo lastb | head

}

log_action "viewed listening ports"
listening_ports() {

    echo
    echo "===== Listeing TCP/UDP Ports ====="

    ss -tuln

}

log_action "viewed processes information"
memeory_processes() {

    echo
    echo "===== Top Memory Usage ======"

    ps aux --sort=-%mem | head

}

log_action "viewed system health"
system_health() {

    uptime

    free -h

    df -h

}

log_action "threat hunt started"
threat_hunt() {

    warnings=0
    score=100

    if [ "$usage" -gt 80 ]
    then
        echo -e "${YELLOW}[warning]${NC} Disk usage is ${usage}%"
        score=$((score-10))
        warnings=$((warnings+1))
    else
        echo -e "${GREEN}[OK]${NC} Disk usage is ${usage}%"
    fi

    if [ "$memory" -gt 80 ]
    then
        echo -e "${YELLOW}[warning]${NC} Memory is ${memory}%"
        score=$((score-10))
        warnings=$((warnings+1))
    else
        echo "[ok] Memory is ${memory}%"
    fi

    echo
    echo "===== linux threat hunt ====="
    echo
    echo "checking disk usage..."

    echo "Checking disk usage..."
    sleep 1
    usage=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

    if [ "$usage" -gt 80 ]
    then
       echo -e "${YELLOW}[warning]${NC} disk usage is ${usage}%"

    else
       echo "${GREEN}[ok]${NC} disk usage is ${usage}%"
    fi

    echo

    echo "Checking memory..."
    sleep 1
    memory=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

    if [ "$memory" -gt 80 ]
    then
       echo -e "${YELLOW}[warning]${NC} memory usage is ${memory}%"
    else
       echo -e "${GREEN}[ok]${NC} memory usage is ${memory}%"
    fi

    echo
    echo "current load average"

    uptime

    echo

    echo "Checking network..."
    sleep 1
    ports=$(ss -tuln | tail -n +2 | wc -1)

    echo "listening ports: $ports"

    echo

    failures=$(sudo lastb|wc -1)

    echo "failed login entries: $failures"

    echo

    processes=$(ps -e --no-headers | wc -1)

    echo "running processes: $processes"

    echo
    echo "================================"
    echo "security score: $score / 100"
    echo "================================"

    if [ "$score" -ge 90
    then
        echo "overall status: healthy"
    elif [ "$score" -ge 70 ]
    then
        echo "overall status: needs attention"
    else
        echo "overall status: investigate immediately"
    fi

    if command -v ss >/dev/null 2>&1
    then
        ss -tuln
    else
        echo "the 'ss' command is not installed."
    fi

    echo
    echo "==========================="
    echo "Threat Hunt Summary"
    echo "==========================="

    echo "Warnings: $warnings"

    echo "Security Score: $score/100"

    echo
    echo -e "${GREEN}Threat Hunt Complete${NC}"

    read -p "save this report? (y/n): " answer

    if [ "$answer" = "y" ]
    then
       save_report
    fi
}
while true
do

    clear

    echo " Linux Incident Response Toolkit"

    echo " Host: $(hostname)"
    echo " User: $(whoami)"
    echo " Date: $(date)"

    echo -e "${BLUE}"
    echo "=============================="
    echo " Linux Incident Response Toolkit"
    echo "=============================="
    echo -e "${NC}"
    echo
    echo "1) System information"
    echo "2) Running Processes"
    echo "3) Network Connections"
    echo "4) Logged-in Users"
    echo "5) Disk Usage"
    echo "6) Memory Usage"
    echo "7) Save Full Report"
    echo "8) Recent logins"
    echo "9) Failed logins"
    echo "10) listening ports"
    echo "11) memory processes"
    echo "12) Exit"
    echo "13) run threat hunt"
    echo "14) system health check"
    echo

    read -p "choose an option: " choice

    case $choice in

    1)
        system_info
        ;;
    2)
        process_info
        ;;
    3)
        network_info
        ;;
    4)
        logged_in_users
        ;;
    5)
        disk_usage
        ;;
    6)
        memory_info
        ;;
    7)
        timestamp=$(date +"%y-%m-%d_%H-%M-%S")
        REPORT_DIR="$HOME/incident_reports"

        mkdir -p "$REPORT_DIR"

        reports="$REPORT_DIR/incident_report_${timestamp}.txt"
        echo "creating report: $reports"
        echo "Incident Response Reports" > "$reports"
        echo "Generated: $(date)" >> "$reports"

        echo "==============================" >> "$reports"

        echo >> "$reports"

        echo "System Information" >> "$reports"

        hostname >> "$reports"

        whoami >> "$reports"

        uname -r >> "$reports"

        echo >> "$reports"

        echo "Top Processes" >> "$reports"

        ps aux --sort=-%cpu | head >> "$reports"

        echo >> "$reports"

        echo "Network Connections" >> "$reports"

        ss -tuln >> "$reports"

        echo >> "$reports"

        echo "logged-in users" >> "$reports"

        who >> "$reports"

        echo >> "$reports"

        echo "Disk Ussge" >> "$reports"

        df -h >> "$reports"

        echo "Recent Logins" >> "$reports"

        last | head -10 >> "$reports"

        echo "failed logins" >> "$reports"

        sudo lastb | head >> "$reports"

        echo "listening ports" >> "$reports"

        ss -tuln >> "$reports"

        echo "memory processes" >> "$reports"

        ps aux --sort=-%mem | head >> "$reports"

        echo "threat hunt" >> "$reports"

        echo
        echo "Report saved successfully"
        echo
        ;;
    8)
        recent_logins
        ;;
    9)
        failed_logins
        ;;
    10)
        listening_ports
        ;;
    11)
        memory_processes
        ;;
    12)
        echo
        echo "Goodbye!"
        break
        ;;
    13)
        threat_hunt
        ;;
    14)
        system_health
        ;;
    *)
        echo
        echo "invalid option."
        ;;
    esac

    read -p "press enter to continue..."
    clear

    done
