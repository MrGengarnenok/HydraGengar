#!/bin/bash

# Укажите путь к вашему репозиторию
REPO_URL="https://github.com/MrGengarnenok/HydraGengar"
REPO_DIR="/tmp/HydraGengar"

# Функция для проверки обновлений
check_updates() {
    echo "Проверка обновлений..."
    if [ ! -d "$REPO_DIR" ]; then
        git clone "$REPO_URL" "$REPO_DIR"
    else
        git -C "$REPO_DIR" fetch
    fi
    
    LOCAL=$(git -C "$REPO_DIR" rev-parse @)
    REMOTE=$(git -C "$REPO_DIR" rev-parse origin/main)

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Есть обновления в репозитории."
        echo "Обновляем репозиторий..."
        git -C "$REPO_DIR" pull
    else
        echo "Репозиторий обновлен."
    fi
}

# Функция для проверки безопасности сети
check_network_security() {
    local ssid="$1"
    echo "Проверка сети: $ssid"

    if [[ "$ssid" == *"WPA"* || "$ssid" == *"WPA2"* ]]; then
        echo "Сеть $ssid безопасная."
        return 0
    else
        echo "Сеть $ssid небезопасная."
        return 1
    fi
}

# Функция для сканирования уязвимостей
scan_vulnerabilities() {
    local ip="$1"
    echo "Сканирование уязвимостей для IP: $ip"
    nmap -sV --script=vuln "$ip"
}

# Функция для получения списка устройств в сети
discover_devices() {
    local ip="$1"
    echo "Сканирование устройств в сети..."
    nmap -sn "$ip/24"
}

# ASCII-арт для заголовка
echo -e "\e[34m"
echo "  _    _ _    _       _        _       "
echo " | |  | | |  | |     | |      | |      "
echo " | |__| | |  | | ___ | | _____| |_ ___ "
echo " |  __  | |  | |/ _ \| |/ / _ \ __/ _ \ "
echo " | |  | | |__| | (_) |   <  __/ ||  __/ "
echo " |_|  |_|\____/ \___/|_|\_\___|\__\___| "
echo -e "\e[0m"

# Проверка обновлений перед показом меню
check_updates

# Меню выбора действия
echo "Выберите действие:"
echo "1) Проверить доступные сети"
echo "2) Сканировать уязвимости"
echo "3) Узнать устройства в сети"
echo "4) Выйти"

read -p "Введите номер вашего выбора: " choice

case $choice in
    1)
        echo "Сканируем сети..."
        networks=$(nmcli -t -f SSID dev wifi)

        if [[ -z "$networks" ]]; then
            echo "Нет доступных сетей."
            exit 1
        fi

        for ssid in $networks; do
            if check_network_security "$ssid"; then
                echo "Подключаемся к $ssid..."
                nmcli dev wifi connect "$ssid"
                break
            fi
        done
        ;;
    2)
        ip=$(hostname -I | awk '{print $1}')
        scan_vulnerabilities "$ip"
        ;;
    3)
        ip=$(hostname -I | awk '{print $1}')
        discover_devices "$ip"
        ;;
    4)
        echo "Выход из программы."
        exit 0
        ;;
    *)
        echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
        ;;
esac
