#!/bin/bash

# Цвета ANSI
ORANGE='\033[0;33m'   # оранжевый/желтый
BLUE='\033[0;34m'     # синий
GREEN='\033[0;32m'    # зеленый
NC='\033[0m'          # сброс цвета

# Определение цвета логотипа (по умолчанию оранжевый)
LOGO_COLOR=$ORANGE

# Обработка аргументов цвета
for arg in "$@"; do
    case $arg in
        -orange)
            LOGO_COLOR=$ORANGE
            ;;
        -blue)
            LOGO_COLOR=$BLUE
            ;;
        -green)
            LOGO_COLOR=$GREEN
            ;;
        -nc)
            LOGO_COLOR=$NC
            ;;
    esac
done

# --- Функция для определения типа видеокарты ---
get_gpu_type() {
    local gpu_name=$1
    if [[ "$gpu_name" == *"Intel"* ]] || [[ "$gpu_name" == *"AMD"* && "$gpu_name" != *"Radeon"* ]]; then
        echo "[Integrated]"
    else
        echo "[Discrete]"
    fi
}

# --- Логотип ---
echo -e "${LOGO_COLOR}"
if [[ "$*" == *"-ryzen"* ]]; then
    cat << "EOF"
                                                                           
                                    ▓▒▒▒                                                            
                                  ▒▒▒▒▒▒▒                                                           
                                ▓▒▒▒▒▒▒▒▒▒                                                          
                               ▒▒▒▒▒▒▒▒▒▒▒▓                                                         
                             ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█                                                       
                            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                                   █▓▓                 
                          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█                              ▓▓█████▓▓▓              
                        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒                           ▓▓██████████▓              
                       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                        ▓▓█████████████▓              
                      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓                      ▓████████████████▓              
                    █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                   ▓████████▓▓▓▓███████▓             
                   █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                ▓▓███████▓▓▓██▓█████████▓            
                  █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒          ▓▓  ▓████████▓▓▓███▓▓██████████▓           
                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓        ▓██▓▓███████▓▓██████▓███████████▓           
                 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██▓▓    █▓███████████▓▓██████▓▓███████████▓█▓▓        
                 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓█████████████▓▓█████▓█▓▓█████████▓███▓       
           ▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓████████████▓▓███████▓▓█████████████▓       
           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████▓██████▓▓▓███████████████▓       
           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓▓▓▓▓▓▓████████████████▓▓██████▓▓█████████████████▓       
            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒░▓▓▓░▓▓▓▓▓▓▓▓███████████████▓▓▓███▓▓▓▓█████████████████▓       
            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒▒▒░▓░▓░░░░▓▓████████████████▓█▓▓▓▓▓▓████████████████████       
           ▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒░▒▒▓░▓▓▓▓▓░▓▓░░░███████████████████████████████████████▓        
         ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓░▓▓▓▓░▓▓▓░█▓██░░██░█████████████████████████████████▓         
        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓░▓▓▓▓▓░░░██░█░█░████████████████████████████████▓          
       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▓▓▓▓▓▓▓▓░░░░▓▓░▓▓▓▓░▓▓░░███████████████████████████████▓▓           
           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░▓█░▓▓▓░▓▓▓████████████████████████▓░ ░░▒▓         
         ▒ ░▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░▓▓▓░▓▓██▓▓█████████████████▒░   ░▒▒          
       ░░░  ░░▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▓▓▓▓▓▓▓░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████████████████████░░    ░▒            
          ░░    ░░▒▒▓▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓░▓▓▓▓░░▓▓▓▓▓▓▓▓▓▓▓████████████████████░░    ░▒              
            ▒▒░    ░▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░▓▓▓▓▓▓▓▓░░▓▓▓▓▓▓▓█████████████████████████▓█               
               ▒▒░    ░░▒▒▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████               
                  ▒░░    ░░▒▒▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████                  
                     ▒▒░    ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████                      
                       ▒▒░     ░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▓    ░░▓                        
                          ▓▒░░     ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▒  ░▒                           
                             ▓▒▒░     ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████ ░▒                             
                                ▓▒▒░     ░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓███████████▒                               
                                   ▓▒▒░     ░░░▒▒▓▓▓▓█▓▓▒░░▓████████                                
                                      █▓▒░     ░░▒▒▒░░░░░░░  ██████                                 
                                         ▓▒▒░               ░░████                                  
                                            █▓▒░          ░░▓  █                                    
                                               █▓▓░░    ░▒▓                                         
                                                  █▓▓░░▒▓                                           
                                                     █    
EOF
else
    cat << "EOF"
        ░ ░░░░                            ░░░░░░
        ░░░░░░                            ░░░░░░
        ░░░▓▓░░░░   ░░░░░░░░░░░░░░░░░  ░░░░▒▒░░
         ░░▓▓▓▓▓▓░░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░▒▒▒▒▒▒░░
           ░▓▓▓▓▓▓▓▓▓░░░▒▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒░
           ░░▓▓▓▓▓▓▓▓▓▓▒░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒░░
        ░░░▒▓▓░░░░░░░░░▓▓░░▒▒░░▒▒░░░░░░░░░▒▒░░░░
        ░░▓▓▓░   ░██░░░░▓▓░░░▒▒▒░░▒░██░░░░░▒▒▒░░
        ░░▓▓░░ ░░██░░░█░░▓▓░░▒▒░░▒░░░██░  ░░▒▒░
        ░░▓▓░  ░░███▓█▓░░▓▓░░▒▒░░██▓███░░ ░░▒▒░░
        ░░▓▓░░   ░░█▓░░░░▓▓░░▒▒░░░░▓█░░   ░░▒▒░░
         ░░▓▓░░░░  ░░░░▒▓▓░░░░▒▒░░░░░░  ░░░░▒▒░░░
        ░░░░▓▓▓▓░░░░░▓▓▓▒░░▒▒░░▒▒▒▒░░░░░▒▒▒▒░░░░
           ░░░░▓▓▓▓▓▓▒░░░░░▒▒░░░░░▒▒▒▒▒▒▒░░░░
           ░░░▒▒░░░░░▒▒▒▒▒░░░░▒▒▒▒▒░░░░░▒▒░░░
           ░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░
              ░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░
                 ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░
                 ░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░
                   ░░░░▒▒▒▒▒▒▒▒▒▒░░░░
                      ░░░▒▒▒▒▒▒░░░
                      ░░░░░▒▒░░░░░
                         ░░░░░░
EOF
fi
echo -e "${NC}"

# --- Информация ---

# OS
OS=$(lsb_release -d 2>/dev/null | cut -d ':' -f 2 | sed 's/^[ \t]*//')
if [ -z "$OS" ]; then
  OS=$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"')
fi

# Kernel
KERNEL=$(uname -r)

# Hostname
HOSTNAME=$(hostname)

# Uptime
UPTIME=$(uptime -p)

# Shell
SHELL=$(basename "$SHELL")

# Resolution
RESOLUTION=$(xrandr | grep '*' | awk '{print $1}' | head -n1)

# DE or WM
DE=$(echo $XDG_CURRENT_DESKTOP)
if [ -z "$DE" ]; then
  DE=$(wmctrl -m 2>/dev/null | grep Name | cut -d ':' -f2 | sed 's/^[ \t]*//')
fi
if [ -z "$DE" ]; then DE="N/A"; fi

# WM Theme, GTK Theme, Icon Theme — попробуем из gsettings (GNOME/GTK)
GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
WM_THEME=$(gsettings get org.gnome.desktop.wm.preferences theme 2>/dev/null | tr -d "'")

# CPU
CPU=$(grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f 2 | sed 's/^[ \t]*//')

# GPU (все видеокарты, каждая на отдельной строке)
GPU_COUNT=0
while IFS= read -r line; do
    GPU_NAME=$(echo "$line" | cut -d ':' -f3 | sed 's/^[ \t]*//')
    GPU_TYPE=$(get_gpu_type "$GPU_NAME")
    GPUS[$GPU_COUNT]="${GPU_NAME} ${GPU_TYPE}"
    ((GPU_COUNT++))
done < <(lspci | grep -i 'vga\|3d\|2d')

# RAM (used/total)
RAM=$(free -h | awk '/Mem:/ {print $3 " / " $2}')

# Disk (root partition usage)
DISK=$(df -h / | awk 'NR==2{print $3 " / " $2}')

# Terminal
TERMINAL="$TERM"

# Battery (если есть)
BATTERY=""
if command -v acpi >/dev/null 2>&1; then
  BATTERY=$(acpi -b | head -n1 | cut -d ',' -f2 | sed 's/^ //')
fi

# Locale
LOCALE=$(locale | grep LANG= | cut -d= -f2)

# CPU Usage (средняя загрузка по 1 минуте)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

# --- Вывод с цветами ---

echo -e "${BLUE}┌───────────────────────────────┐${NC}"
echo -e "${BLUE}│       ${GREEN}System Information      ${BLUE}│${NC}"
echo -e "${BLUE}└───────────────────────────────┘${NC}"

echo -e "${GREEN}Hostname:${NC}      $HOSTNAME"
echo -e "${GREEN}OS:${NC}            $OS"
echo -e "${GREEN}Kernel:${NC}        $KERNEL"
echo -e "${GREEN}Uptime:${NC}        $UPTIME"
echo -e "${GREEN}Shell:${NC}         $SHELL"
echo -e "${GREEN}Resolution:${NC}    $RESOLUTION"
echo -e "${GREEN}DE / WM:${NC}       $DE"
echo -e "${GREEN}WM Theme:${NC}      ${WM_THEME:-N/A}"
echo -e "${GREEN}GTK Theme:${NC}     ${GTK_THEME:-N/A}"
echo -e "${GREEN}Icon Theme:${NC}    ${ICON_THEME:-N/A}"
echo -e "${GREEN}CPU:${NC}           $CPU"

# Вывод информации о видеокартах
if [ $GPU_COUNT -gt 0 ]; then
    echo -e "${GREEN}GPU:${NC}           ${GPUS[0]}"
    for (( i=1; i<$GPU_COUNT; i++ )); do
        echo -e "               ${GPUS[$i]}"
    done
else
    echo -e "${GREEN}GPU:${NC}           N/A"
fi

echo -e "${GREEN}RAM Usage:${NC}      $RAM"
echo -e "${GREEN}Disk Usage:${NC}     $DISK"
echo -e "${GREEN}Terminal:${NC}      $TERMINAL"
if [ -n "$BATTERY" ]; then
  echo -e "${GREEN}Battery:${NC}       $BATTERY"
fi
echo -e "${GREEN}Locale:${NC}        $LOCALE"
echo -e "${GREEN}CPU Usage:${NC}     $CPU_USAGE"

# Внизу цвета терминала для проверки темы
echo -e "\n${BLUE}Terminal colors:${NC}"
for i in {0..7}; do
  echo -ne "\033[38;5;${i}m█\033[0m "
done
for i in {8..15}; do
  echo -ne "\033[38;5;${i}m█\033[0m "
done
echo
