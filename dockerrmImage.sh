#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
names=$(docker image ls --format "{{.Repository}}")
choice="aaa" 

if [[ -z "$names" ]];then
    echo "Nothing to remove."
    exit 0 
else
    mapfile -t nameArr <<< "$names"
    if [[ "${#nameArr[@]}" -eq 0 ]]; then
        echo -e "${BLUE}Nothing to remove${NC}"
        exit 0 
    # elif [[ "${#nameArr[@]}" -eq 1 ]]; then
    #     docker kill ${nameArr[0]}
    #     exit 1
    else
        echo ""
        echo -e "${BLUE}-Docker IMAGE Remove-${NC}"
        echo "Choose which image do you want to remove :"
        for i in "${!nameArr[@]}"; do
            printf "%5s. ${YELLOW} %-20s${NC}\n" "$(($i + 1))" "${nameArr[$i]}" 
        done
        while [[ ! ( "$choice" =~ ^[0-9]+$ ) || "$choice" -gt "${#nameArr[@]}" || "$choice" -lt 0 ]]; do
            echo "Choice: "
            read c
            if [[ "$c" =~ ^[0-9]+$ ]]; then
                choice=$((c - 1))
            fi
        done
        choice="${nameArr[choice]}"
        res=$(docker image rm $choice 2>&1)
        if [ $? -eq 0 ]; then
            echo -e "${BLUE}Removed image: $choice.${NC}"
            exit 0
        else
            echo -e "${BLUE}Failed to remove $choice, Error:${NC}"
            echo -e "${RED}$res${NC}"
            exit 1
        fi
    fi
fi
