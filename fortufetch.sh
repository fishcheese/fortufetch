#!/bin/bash

BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
LIGHT_YELLOW='\033[1;33m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
ORANGE='\033[0;33m'
PINK='\033[1;35m'
NC='\033[0m'

PRIMARY=$WHITE
SECONDARY=$LIGHT_GRAY
BORDER=$DARK_GRAY
BACKGROUND=$BLACK

# Установка цвета акцента по умолчанию
ACCENT=$ORANGE  # По умолчанию оранжевый

RYZEN_MODE=false
MINIMAL=false
for arg in "$@"; do
    case $arg in
        --blue) ACCENT=$LIGHT_BLUE ;;
        --green) ACCENT=$GREEN ;;
        --purple) ACCENT=$PURPLE ;;
        --cyan) ACCENT=$CYAN ;;
        --red) ACCENT=$RED ;;
        --yellow) ACCENT=$YELLOW ;;
        --orange) ACCENT=$ORANGE ;;
        --pink) ACCENT=$PINK ;;
        --white) ACCENT=$WHITE ;;
        --minimal) 
            MINIMAL=true
            # Если цвет не указан явно и включен минимальный режим, устанавливаем белый
            [[ ! "$*" =~ --(blue|green|purple|cyan|red|yellow|orange|pink|white) ]] && ACCENT=$WHITE
            ;;
        --ryzen) 
            RYZEN_MODE=true
            # Если цвет не указан явно и включен режим Ryzen, устанавливаем розовый
            [[ ! "$*" =~ --(blue|green|purple|cyan|red|yellow|orange|pink|white) ]] && ACCENT=$PINK
            ;;
        --help)
            echo -e "${WHITE}Использование: fortufetch${NC}"
            echo
            echo -e "${ACCENT}Атрибуты:${NC}"
            echo -e "  --blue      ${LIGHT_BLUE}Сменить цвет акцента на синий${NC}"
            echo -e "  --green     ${GREEN}Сменить цвет акцента на зелёный${NC}"
            echo -e "  --purple    ${PURPLE}Сменить цвет акцента на фиолетовый${NC}"
            echo -e "  --cyan      ${CYAN}Сменить цвет акцента на голубой${NC}"
            echo -e "  --red       ${RED}Сменить цвет акцента на красный${NC}"
            echo -e "  --yellow    ${YELLOW}Сменить цвет акцента на жёлтый${NC}"
            echo -e "  --orange    ${ORANGE}Сменить цвет акцента на оранжевый${NC}"
            echo -e "  --pink      ${PINK}Сменить цвет акцента на розовый${NC}"
            echo -e "  --white     ${WHITE}Сменить цвет акцента на белый${NC}"
            echo -e "  --ryzen     Включить режим Ryzen (альтернативный логотип)"
            echo -e "  --minimal   Включить минимальный режим (без логотипа)"
            echo -e "  --help      Показать это сообщение справки"
            exit 0
            ;;
    esac
done

get_gpu_info() {
    local gpus=()
    while IFS= read -r line; do
        local gpu_name=$(echo "$line" | cut -d ':' -f3 | sed 's/^[ \t]*//;s/\s*$//')
        if [[ -n "$gpu_name" ]]; then
            if [[ "$gpu_name" == *"Intel"* ]] || [[ "$gpu_name" == *"AMD"* && "$gpu_name" != *"Radeon"* ]]; then
                gpus+=("${gpu_name} [Integrated]")
            else
                gpus+=("${gpu_name} [Discrete]")
            fi
        fi
    done < <(lspci | grep -i 'vga\|3d\|2d')
    
    # Объединяем все видеокарты в одну строку с переносами
    local result=""
    for ((i=0; i<${#gpus[@]}; i++)); do
        if [ $i -eq 0 ]; then
            result+="${gpus[$i]}"
        else
            result+="\n              ${SECONDARY}${gpus[$i]}"
        fi
    done
    
    # Если видеокарты не найдены
    if [ -z "$result" ]; then
        result="Unknown"
    fi
    
    echo -e "$result"
}

STANDARD_LOGO=(
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

RYZEN_LOGO=(
    "${ACCENT}                                    ▓▒▒▒                                                            ${NC}"
    "${ACCENT}                                  ▒▒▒▒▒▒▒                                                           ${NC}"
    "${ACCENT}                                ▓▒▒▒▒▒▒▒▒▒                                                          ${NC}"
    "${ACCENT}                               ▒▒▒▒▒▒▒▒▒▒▒▓                                                         ${NC}"
    "${ACCENT}                             ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█                                                       ${NC}"
    "${ACCENT}                            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                                   █▓▓                 ${NC}"
    "${ACCENT}                          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█                              ▓▓█████▓▓▓              ${NC}"
    "${ACCENT}                        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒                           ▓▓██████████▓              ${NC}"
    "${ACCENT}                       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        ▓▓█████████████▓              ${NC}"
    "${ACCENT}                      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓                      ▓████████████████▓              ${NC}"
    "${ACCENT}                    █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                   ▓████████▓▓▓▓███████▓             ${NC}"
    "${ACCENT}                   █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                ▓▓███████▓▓▓██▓█████████▓            ${NC}"
    "${ACCENT}                  █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒          ▓▓  ▓████████▓▓▓███▓▓██████████▓           ${NC}"
    "${ACCENT}                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓        ▓██▓▓███████▓██████▓███████████▓           ${NC}"
    "${ACCENT}                 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██▓▓    █▓███████████▓▓██████▓▓███████████▓█▓▓        ${NC}"
    "${ACCENT}                 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓█████████████▓▓█████▓█▓▓█████████▓███▓       ${NC}"
    "${ACCENT}           ▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓████████████▓▓███████▓▓█████████████▓       ${NC}"
    "${ACCENT}           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████▓██████▓▓▓███████████████▓       ${NC}"
    "${ACCENT}           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓▓▓▓▓▓▓████████████████▓▓██████▓▓█████████████████▓       ${NC}"
    "${ACCENT}            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒░▓▓▓░▓▓▓▓▓▓▓▓███████████████▓▓▓███▓▓▓▓█████████████████▓       ${NC}"
    "${ACCENT}            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒▒▒░▓░▓░░░░▓▓████████████████▓█▓▓▓▓▓▓████████████████████       ${NC}"
    "${ACCENT}           ▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒░▒▒▓░▓▓▓▓▓░▓▓░░░███████████████████████████████████████▓        ${NC}"
    "${ACCENT}         ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓░▓▓▓▓░▓▓▓░█▓██░░██░█████████████████████████████████▓         ${NC}"
    "${ACCENT}        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓░▓▓▓▓▓░░░██░█░█░████████████████████████████████▓          ${NC}"
    "${ACCENT}       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▓▓▓▓▓▓▓▓░░░░▓▓░▓▓▓▓░▓▓░░███████████████████████████████▓▓           ${NC}"
    "${ACCENT}           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░▓█░▓▓▓░▓▓▓████████████████████████▓░ ░░▒▓         ${NC}"
    "${ACCENT}         ▒ ░▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░▓▓▓░▓▓██▓▓█████████████████▒░   ░▒▒          ${NC}"
    "${ACCENT}       ░░░  ░░▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▓▓▓▓▓▓░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████████░░    ░▒            ${NC}"
    "${ACCENT}          ░░    ░░▒▒▓▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓░▓▓▓▓░░▓▓▓▓▓▓▓▓▓████████████████████████░░    ░▒              ${NC}"
    "${ACCENT}            ▒▒░    ░▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░▓▓▓▓▓▓▓▓░░▓▓▓▓▓█████████████████████████████▓█               ${NC}"
    "${ACCENT}               ▒▒░    ░░▒▒▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████████               ${NC}"
    "${ACCENT}                  ▒░░    ░░▒▒▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████                  ${NC}"
    "${ACCENT}                     ▒▒░    ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████                      ${NC}"
    "${ACCENT}                       ▒▒░     ░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▓    ░░▓                        ${NC}"
    "${ACCENT}                          ▓▒░░     ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▒  ░▒                           ${NC}"
    "${ACCENT}                             ▓▒▒░     ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓███████████ ░▒                             ${NC}"
    "${ACCENT}                                ▓▒▒░     ░░▒▒▓▓▓▓▓▓▓▓▓▓███████████▒                               ${NC}"
    "${ACCENT}                                   ▓▒▒░     ░░░▒▒▓▓▓▓█▓▓▒░░▓████████                                ${NC}"
    "${ACCENT}                                      █▓▒░     ░░▒▒▒░░░░░░░  ██████                                 ${NC}"
    "${ACCENT}                                         ▓▒▒░               ░░████                                  ${NC}"
    "${ACCENT}                                            █▓▒░          ░░▓  █                                    ${NC}"
    "${ACCENT}                                               █▓▓░░    ░▒▓                                         ${NC}"
    "${ACCENT}                                                  █▓▓░░▒▓                                           ${NC}"
    "${ACCENT}                                                     █${NC}"
)

if [ "$RYZEN_MODE" = true ]; then
    LOGO=("${RYZEN_LOGO[@]}")
else
    LOGO=("${STANDARD_LOGO[@]}")
fi

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

# Создаем массив строк информации
INFO_LINES=(
    "${PRIMARY}${HOSTNAME}${SECONDARY}@${ACCENT}$(whoami)${NC}"
    "${BORDER}$(printf '%.0s─' {1..40})${NC}"
    "${ACCENT}🗗 ${PRIMARY}OS${NC}         ${SECONDARY}${OS}${NC}"
    "${ACCENT}├─  ${PRIMARY}Host${NC}       ${SECONDARY}${HOSTNAME}${NC}"
    "${ACCENT}├─  ${PRIMARY}Kernel${NC}     ${SECONDARY}${KERNEL}${NC}"
    "${ACCENT}├─  ${PRIMARY}Uptime${NC}     ${SECONDARY}${UPTIME}${NC}"
    "${ACCENT}└─  ${PRIMARY}Shell${NC}      ${SECONDARY}${SHELL}${NC}"
    ""
    "${ACCENT}┌─  ${PRIMARY}Resolution${NC} ${SECONDARY}${RESOLUTION}${NC}"
    "${ACCENT}├─  ${PRIMARY}DE/WM${NC}      ${SECONDARY}${DE}${NC}"
    "${ACCENT}├─  ${PRIMARY}CPU${NC}        ${SECONDARY}${CPU}${NC}"
)

# Обрабатываем GPU отдельно, так как это может быть многострочный вывод
IFS=$'\n' read -rd '' -a GPU_LINES <<< "$(echo -e "$GPU")"
INFO_LINES+=("${ACCENT}├─  ${PRIMARY}GPU${NC}        ${SECONDARY}${GPU_LINES[0]}${NC}")
for ((i=1; i<${#GPU_LINES[@]}; i++)); do
    INFO_LINES+=("${ACCENT}│${SECONDARY}${GPU_LINES[$i]}${NC}")
done

INFO_LINES+=("${ACCENT}├─  ${PRIMARY}Memory${NC}     ${SECONDARY}${RAM}${NC}")
INFO_LINES+=("${ACCENT}├─  ${PRIMARY}Disk${NC}       ${SECONDARY}${DISK}${NC}")

if [ -n "$BATTERY" ]; then
    INFO_LINES+=("${ACCENT}├─  ${PRIMARY}Battery${NC}    ${SECONDARY}${BATTERY}${NC}")
fi

INFO_LINES+=("${ACCENT}├─  ${PRIMARY}Locale${NC}     ${SECONDARY}${LOCALE}${NC}")
INFO_LINES+=("${ACCENT}└─  ${PRIMARY}CPU Usage${NC}  ${SECONDARY}${CPU_USAGE}${NC}")
INFO_LINES+=("")

PALETTE="${SECONDARY}Colors: "
# 8 normal colors
colors=("$BLACK" "$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN" "$WHITE")
# 8 bright colors
bright_colors=("$DARK_GRAY" "$LIGHT_RED" "$LIGHT_GREEN" "$LIGHT_YELLOW" "$LIGHT_BLUE" "$LIGHT_PURPLE" "$LIGHT_CYAN" "$LIGHT_WHITE")

for color in "${colors[@]}" "${bright_colors[@]}"; do
    PALETTE+="${color}███${NC}"
done
INFO_LINES+=("$PALETTE")

get_string_length() {
    echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m
}

echo

if [ "$MINIMAL" = true ]; then
    # В минимальном режиме просто выводим информацию без логотипа
    for line in "${INFO_LINES[@]}"; do
        echo -e "$line"
    done
else
    # Обычный режим с логотипом
    logo_width=0
    for line in "${LOGO[@]}"; do
        line_length=$(get_string_length "$line")
        if [ $line_length -gt $logo_width ]; then
            logo_width=$line_length
        fi
    done

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
fi

echo
