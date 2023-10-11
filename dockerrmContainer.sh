#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
names=$(docker ps -a --format "{{.Names}}")
images=$(docker ps -a --format "{{.Image}}")
choice="aaa" 

if [[ -z "$names" ]];then
    echo "Nothing to remove."
else
    mapfile -t nameArr <<< "$names"
    mapfile -t imgArr <<< "$images"

    if [[ "${#nameArr[@]}" -eq 0 ]]; then
        echo -e "${BLUE}Nothing to kill${NC}"
        exit 1
    else

        echo ""
        echo -e "${BLUE}-Docker CONTAINER Remove-${NC}"
        echo "Choose which container do you want to remove :"

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
        res=$(docker container rm $choice 2>&1)
        if [ $? -eq 0 ]; then
            echo -e "${BLUE}Removed container: $choice.${NC}"
            exit 0
        else
            echo -e "${RED}Failed to remove $choice.${NC}"
            kill_it=true
            #echo -e "${RED}$res${NC}"
            echo "This is likely due to the fact the container is still running."
            echo "Do you want to kill the container ? [Y/n]"
            while true; do
                read input
                if [[ "$input" == "" || "$input" == "y" || "$input" == "Y" ]];then
                    docker kill $choice
                    docker container rm $choice
                    if [ $? -eq 0 ]; then
                        echo -e "${BLUE}Removed container: $choice.${NC}"
                        exit 0
                    else
                        echo -e "${BLUE}Failed to remove $choice, Error:${NC}"
                        echo -e "${RED}$res${NC}"
                        exit 1
                    fi
                    
                    exit 0
                else
                    echo "Aborting..."
                    exit 0
                fi
            done
            exit 1
        fi
    fi
fi
