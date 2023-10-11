#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
names=$(docker ps --format "{{.Names}}")
images=$(docker ps --format "{{.Image}}")
choice="aaa" 

if [[ -z "$names" ]];then
    echo "Nothing to kill."
else
    mapfile -t nameArr <<< "$names"
    mapfile -t imgArr <<< "$images"
    if [[ "${#nameArr[@]}" -eq 0 ]]; then
        echo -e "${BLUE}Nothing to kill${NC}"
        exit 0 
    elif [[ "${#nameArr[@]}" -eq 1 ]]; then
        docker kill ${nameArr[0]}
        exit 0 
    else
        echo ""
        echo -e "${BLUE}-Dockerkill-${NC}"
        echo "Choose which container you want to kill :"
        for i in "${!nameArr[@]}"; do
            printf "%5s. ${YELLOW} %-20s${NC} %-20s\n" "$(($i + 1))" "${nameArr[$i]}" "${imgArr[$i]}"
        done
        while [[ ! ( "$choice" =~ ^[0-9]+$ ) || "$choice" -gt "${#nameArr[@]}" || "$choice" -lt 0 ]]; do
            echo "Choice: (a/A for all)"
            read c
            if [[ "$c" =~ ^[0-9]+$ ]]; then
                choice=$((c - 1))
            else
                choice="a"
                break
            fi
        done
        if [[ "$c" =~ ^[0-9]+$ ]]; then
            choice="${nameArr[choice]}"
            docker kill $choice
            echo -e "${BLUE}Killed container: $choice.${NC}"
            exit 0 
        else
            for i in "${!nameArr[@]}"; do
                docker kill ${nameArr[$i]}
            done
            echo -e "${BLUE}Killed all containers.${NC}"
            exit 0 
        fi
    fi
fi

