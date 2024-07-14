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

# Функция для выполнения атаки на логин с помощью Hydra
perform_hydra_attack() {
    local target="$1"
    local service="$2"
    local username="$3"
    local password_list="$4"
    echo "Выполнение атаки на $target с помощью Hydra..."
    hydra -l "$username" -P "$password_list" "$target" "$service"
}

# Функция для полного сканирования портов с nmap
full_port_scan() {
    local ip="$1"
    echo "Полное сканирование портов для IP: $ip"
    nmap -p- "$ip"
}

# Функция для получения информации об устройстве по IP
get_device_info() {
    local ip="$1"
    echo "Получение информации об устройстве с IP: $ip"
    nmap -A "$ip"
}

# ASCII-арт для заголовка с драконом и логотипом Kali Linux
echo -e "\e[34m"
echo "                    ___.-----.______.----.___"
echo "                ===(o)==================(o)==="
echo "                    '-----'        '-----'"
echo "          ____            ____  _       _    _           _   "
echo "         |  _ \ ___  __ _/ ___|| | ___ | |_ | |__   ___ | |_ "
echo "         | |_) / _ \/ _' \___ \| |/ _ \| __|| '_ \ / _ \| __|"
echo "         |  __/  __/ (_| |___) | | (_) | |_ | | | |  __/| |_ "
echo "         |_|   \___|\__,_|____/|_|\___/ \__||_| |_|\___| \__|"
echo -e "\e[0m"

# Проверка обновлений перед показом меню
check_updates

# Меню выбора действия
echo "Выберите действие:"
echo "1) Проверить доступные сети"
echo "2) Сканировать уязвимости"
echo "3) Узнать устройства в сети"
echo "4) Выполнить атаку с помощью Hydra"
echo "5) Полное сканирование портов"
echo "6) Получить информацию об устройстве"
echo "7) Выйти"

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
        read -p "Введите цель (IP или домен): " target
        read -p "Введите сервис (например, http, ftp): " service
        read -p "Введите имя пользователя: " username
        read -p "Введите путь к файлу со списком паролей: " password_list
        perform_hydra_attack "$target" "$service" "$username" "$password_list"
        ;;
    5)
        ip=$(hostname -I | awk '{print $1}')
        full_port_scan "$ip"
        ;;
    6)
        read -p "Введите IP-адрес устройства: " device_ip
        get_device_info "$device_ip"
        ;;
    7)
        echo "Выход из программы."
        exit 0
        ;;
    *)
        echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
        ;;
esac
