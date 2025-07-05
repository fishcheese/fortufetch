#!/bin/bash

BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PRIMARY=$WHITE
SECONDARY=$LIGHT_GRAY
ACCENT=$LIGHT_BLUE
BORDER=$DARK_GRAY
BACKGROUND=$BLACK

for arg in "$@"; do
    case $arg in
        --blue) ACCENT=$LIGHT_BLUE ;;
        --green) ACCENT=$GREEN ;;
        --purple) ACCENT=$PURPLE ;;
        --cyan) ACCENT=$CYAN ;;
        --minimal) MINIMAL=true ;;
    esac
done

get_gpu_info() {
    local gpu_info=""
    while IFS= read -r line; do
        local gpu_name=$(echo "$line" | cut -d ':' -f3 | sed 's/^[ \t]*//')
        if [[ "$gpu_name" == *"Intel"* ]] || [[ "$gpu_name" == *"AMD"* && "$gpu_name" != *"Radeon"* ]]; then
            gpu_info="${gpu_name} [Integrated]"
        else
            gpu_info="${gpu_name} [Discrete]"
        fi
        break
    done < <(lspci | grep -i 'vga\|3d\|2d')
    echo "$gpu_info"
}

LOGO=(
    "        ${ACCENT}░ ░░░░                            ░░░░░░${NC}"
    "        ${ACCENT}░░░░░░                            ░░░░░░${NC}"
    "        ${ACCENT}░░░▓▓░░░░   ░░░░░░░░░░░░░░░░░  ░░░░▒▒░░${NC}"
    "         ${ACCENT}░░▓▓▓▓▓▓░░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░▒▒▒▒▒▒░░${NC}"
    "           ${ACCENT}░▓▓▓▓▓▓▓▓▓░░░▒▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒░${NC}"
    "           ${ACCENT}░░▓▓▓▓▓▓▓▓▓▓▒░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒░░${NC}"
    "        ${ACCENT}░░░▒▓▓░░░░░░░░░▓▓░░▒▒░░▒▒░░░░░░░░░▒▒░░░░${NC}"
    "        ${ACCENT}░░▓▓▓░   ░██░░░░▓▓░░░▒▒▒░░▒░██░░░░░▒▒▒░░${NC}"
    "        ${ACCENT}░░▓▓░░ ░░██░░░█░░▓▓░░▒▒░░▒░░░██░  ░░▒▒░${NC}"
    "        ${ACCENT}░░▓▓░  ░░███▓█▓░░▓▓░░▒▒░░██▓███░░ ░░▒▒░░${NC}"
    "        ${ACCENT}░░▓▓░░   ░░█▓░░░░▓▓░░▒▒░░░░▓█░░   ░░▒▒░░${NC}"
    "         ${ACCENT}░░▓▓░░░░  ░░░░▒▓▓░░░░▒▒░░░░░░  ░░░░▒▒░░░${NC}"
    "        ${ACCENT}░░░░▓▓▓▓░░░░░▓▓▓▒░░▒▒░░▒▒▒▒░░░░░▒▒▒▒░░░░${NC}"
    "           ${ACCENT}░░░░▓▓▓▓▓▓▒░░░░░▒▒░░░░░▒▒▒▒▒▒▒░░░░${NC}"
    "           ${ACCENT}░░░▒▒░░░░░▒▒▒▒▒░░░░▒▒▒▒▒░░░░░▒▒░░░${NC}"
    "           ${ACCENT}░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░${NC}"
    "              ${ACCENT}░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░${NC}"
    "                 ${ACCENT}░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░${NC}"
    "                 ${ACCENT}░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░${NC}"
    "                   ${ACCENT}░░░░▒▒▒▒▒▒▒▒▒▒░░░░${NC}"
    "                      ${ACCENT}░░░▒▒▒▒▒▒░░░${NC}"
    "                      ${ACCENT}░░░░░▒▒░░░░░${NC}"
    "                         ${ACCENT}░░░░░░${NC}"
)

clear

OS=$(lsb_release -d 2>/dev/null | cut -d ':' -f 2 | sed 's/^[ \t]*//')
if [ -z "$OS" ]; then
    OS=$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"')
fi

KERNEL=$(uname -r)
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
SHELL=$(basename "$SHELL")
RESOLUTION=$(xrandr | grep '*' | awk '{print $1}' | head -n1)

DE=$(echo $XDG_CURRENT_DESKTOP)
if [ -z "$DE" ]; then
    DE=$(wmctrl -m 2>/dev/null | grep Name | cut -d ':' -f2 | sed 's/^[ \t]*//')
fi
if [ -z "$DE" ]; then DE="Unknown"; fi

CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f 2 | sed 's/^[ \t]*//')
GPU=$(get_gpu_info)
RAM=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
DISK=$(df -h / | awk 'NR==2{print $3 " / " $2}')

BATTERY=""
if command -v acpi >/dev/null 2>&1; then
    BATTERY=$(acpi -b | head -n1 | cut -d ',' -f2 | sed 's/^ //')
fi

LOCALE=$(locale | grep LANG= | cut -d= -f2)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

INFO_LINES=(
    "${PRIMARY}${HOSTNAME}${SECONDARY}@${ACCENT}$(whoami)${NC}"
    "${BORDER}$(printf '%.0s─' {1..40})${NC}"
    "${ACCENT}󰍹 ${PRIMARY}OS${NC}         ${SECONDARY}${OS}${NC}"
    "${ACCENT}├─ ${PRIMARY}Host${NC}       ${SECONDARY}${HOSTNAME}${NC}"
    "${ACCENT}├─ ${PRIMARY}Kernel${NC}     ${SECONDARY}${KERNEL}${NC}"
    "${ACCENT}├─ ${PRIMARY}Uptime${NC}     ${SECONDARY}${UPTIME}${NC}"
    "${ACCENT}└─ ${PRIMARY}Shell${NC}      ${SECONDARY}${SHELL}${NC}"
    "${ACCENT}󰍹 ${PRIMARY}Resolution${NC} ${SECONDARY}${RESOLUTION}${NC}"
    "${ACCENT}󱄅 ${PRIMARY}DE/WM${NC}      ${SECONDARY}${DE}${NC}"
    "${ACCENT}󰻠 ${PRIMARY}CPU${NC}        ${SECONDARY}${CPU}${NC}"
    "${ACCENT}󰾆 ${PRIMARY}GPU${NC}        ${SECONDARY}${GPU}${NC}"
    "${ACCENT}󰍛 ${PRIMARY}Memory${NC}     ${SECONDARY}${RAM}${NC}"
    "${ACCENT}󰋊 ${PRIMARY}Disk${NC}       ${SECONDARY}${DISK}${NC}"
)

if [ -n "$BATTERY" ]; then
    INFO_LINES+=("${ACCENT}󰁹 ${PRIMARY}Battery${NC}    ${SECONDARY}${BATTERY}${NC}")
fi

INFO_LINES+=("${ACCENT}󰇧 ${PRIMARY}Locale${NC}     ${SECONDARY}${LOCALE}${NC}")
INFO_LINES+=("${ACCENT}󰘚 ${PRIMARY}CPU Usage${NC}  ${SECONDARY}${CPU_USAGE}${NC}")
INFO_LINES+=("")

PALETTE="${SECONDARY}Colors: "
colors=("$BLACK" "$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN" "$WHITE")
for color in "${colors[@]}"; do
    PALETTE+="${color}███${NC}"
done
INFO_LINES+=("$PALETTE")

get_string_length() {
    echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m
}

logo_width=0
for line in "${LOGO[@]}"; do
    line_length=$(get_string_length "$line")
    if [ $line_length -gt $logo_width ]; then
        logo_width=$line_length
    fi
done

echo
max_lines=${#LOGO[@]}
info_count=${#INFO_LINES[@]}

if [ $info_count -gt $max_lines ]; then
    max_lines=$info_count
fi

for ((i=0; i<max_lines; i++)); do
    if [ $i -lt ${#LOGO[@]} ]; then
        echo -ne "${LOGO[$i]}"
        current_length=$(get_string_length "${LOGO[$i]}")
        spaces_needed=$((logo_width - current_length + 2))
        printf '%*s' $spaces_needed ''
    else
        printf '%*s' $((logo_width + 2)) ''
    fi
    
    if [ $i -lt ${#INFO_LINES[@]} ]; then
        echo -e "${INFO_LINES[$i]}"
    else
        echo
    fi
done

echo
