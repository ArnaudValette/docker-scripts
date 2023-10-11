#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
names=$(docker ps -a --format "{{.Names}}")
images=$(docker ps -a --format "{{.Image}}")
args="$@"
choice="aaa" 

if [[ -z "$names" ]];then
    echo "Nothing to start."
    exit 0
else
    mapfile -t nameArr <<< "$names"
    mapfile -t imgArr <<< "$images"
    if [[ "${#nameArr[@]}" -eq 0 ]]; then
        echo -e "${BLUE}Nothing to start${NC}"
        exit 0 
    else
        echo ""
        echo -e "${BLUE}-Docker Start-${NC}"
        echo "Choose which container do you want to start :"
        for i in "${!nameArr[@]}"; do
            printf "%5s. ${YELLOW} %-20s${NC} %-20s\n" "$(($i + 1))" "${nameArr[$i]}" "${imgArr[$i]}"
        done
        while [[ ! ( "$choice" =~ ^[0-9]+$ ) || "$choice" -gt "${#nameArr[@]}" || "$choice" -lt 0 ]]; do
            echo "Choice: "
            read c
            if [[ "$c" =~ ^[0-9]+$ ]]; then
                choice=$((c - 1))
            fi
        done
        choice="${nameArr[choice]}"
        docker start $args $choice
    fi
fi
