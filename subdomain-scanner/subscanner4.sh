#!/bin/bash

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[2m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
STOP='\033[0m'

# banner


echo ""
echo -e "${CYAN}${BOLD} ███████╗██╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ███╗ █████╗ ██╗███╗   ██╗    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ ${STOP}"
echo -e "${CYAN}${BOLD} ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔══██╗██║████╗  ██║    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗${STOP}"
echo -e "${CYAN}${BOLD} ███████╗██║   ██║██████╔╝██║  ██║██║   ██║██╔████╔██║███████║██║██╔██╗ ██║    ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝${STOP}"
echo -e "${CYAN}${BOLD} ╚════██║██║   ██║██╔══██╗██║  ██║██║   ██║██║╚██╔╝██║██╔══██║██║██║╚██╗██║    ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗${STOP}"
echo -e "${CYAN}${BOLD} ███████║╚██████╔╝██████╔╝██████╔╝╚██████╔╝██║ ╚═╝ ██║██║  ██║██║██║ ╚████║    ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║${STOP}"
echo -e "${CYAN}${BOLD} ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝${STOP}"

echo -e "\n${GREY}$(date '+%Y-%m-%d %H:%M')${STOP}"


# chck argument
if [[ $# -ne 2 ]]; then
    echo -e "${RED}${BOLD}Usage: $0 <domain> <wordlist>${STOP}\n"
    exit 1
fi

DOMAIN="$1"
WORDLIST="$2"

#check wordlist
if [[ ! -f "$WORDLIST" ]]; then
    echo -e "${RED}error: wordlist not found${STOP}\n"
    exit 1
fi

# host command check
if ! which host &>/dev/null; then
    echo -e "${RED}error: no command host run: sudo apt install dnsutils${STOP}\n"
    exit 1
fi

# internet check
if ! host -W 5 "google.com" &>/dev/null; then
    echo -e "${RED}error: No/slow internet${STOP}\n"
    exit 1
fi


# is domain?
if [[ ! "$DOMAIN" = *[a-zA-Z]* ]]; then
    echo -e "${RED}error: Enter a valid domain name.${STOP}"
    exit 1
fi



# check domain
ping -c 1 "$DOMAIN" &>/dev/null
if [ $? != 0 ]; then
    echo -e "${YELLOW}WARNING: '$DOMAIN' is not live or not correctly written${STOP}"
    read -p "Continue? [y/n]: " ans

    if [[ "$ans" != "y" && "$ans" != "Y" ]]; then
        echo -e "${RED}${BOLD}Abort!${STOP}\n"
        exit 0
    fi

    echo ""
fi


# table header
echo -e "Scan started on ${BOLD}$DOMAIN${STOP} with wordlist ${BOLD}$WORDLIST${STOP}\n"
echo -e "${BOLD}$(cat $WORDLIST | wc -l)${STOP} subdomains to scan\n"
printf "${CYAN}${BOLD}%-40s  %-20s  %s${STOP}\n" "SUBDOMAIN" "IP ADDRESS" "STATUS"
echo -e "${GREY}-----------------------------------------------------------------------${STOP}"

# scan
FOUND=0

while read word || [[ -n "$word" ]]; do
    if [[ "$word" == *#* ]]; then
        continue
    fi

    SUB="${word}.${DOMAIN}"
    IP=$(host -W 5 "$SUB" 2>/dev/null | grep "has address" | head -1 | cut -d ' ' -f 4)

    if [[ -n "$IP" ]]; then
        ((FOUND++))
        printf "${GREEN}%-40s %-20s live${STOP}\n" "$SUB" "$IP"
    fi

done < "$WORDLIST"

# result
echo ""
echo -e "${GREY}Scan done.${STOP} ${GREEN}${BOLD}$FOUND${STOP} subdomains found on ${BOLD}$DOMAIN${STOP}\n"
