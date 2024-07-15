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

# Функции Hydra
hydra_menu() {
    echo "Выберите действие для Hydra:"
    echo "1) Выполнить атаку на логин"
    echo "2) Вернуться в главное меню"
    read -p "Введите номер вашего выбора: " hydra_choice

    case $hydra_choice in
        1)
            read -p "Введите цель (IP или домен): " target
            read -p "Введите сервис (например, http, ftp): " service
            read -p "Введите имя пользователя: " username
            read -p "Введите путь к файлу со списком паролей: " password_list
            echo "Выполнение атаки на $target с помощью Hydra..."
            hydra -l "$username" -P "$password_list" "$target" "$service"
            ;;
        2)
            main_menu
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
            hydra_menu
            ;;
    esac
}

# Функции nmap
nmap_menu() {
    echo "Выберите действие для nmap:"
    echo "1) Полное сканирование портов"
    echo "2) Сканировать уязвимости"
    echo "3) Узнать устройства в сети"
    echo "4) Получить информацию об устройстве"
    echo "5) Вернуться в главное меню"
    read -p "Введите номер вашего выбора: " nmap_choice

    case $nmap_choice in
        1)
            read -p "Введите IP-адрес: " ip
            echo "Полное сканирование портов для IP: $ip"
            nmap -p- "$ip"
            ;;
        2)
            read -p "Введите IP-адрес: " ip
            scan_vulnerabilities "$ip"
            ;;
        3)
            read -p "Введите IP-адрес вашей сети: " ip
            discover_devices "$ip"
            ;;
        4)
            read -p "Введите IP-адрес устройства: " ip
            get_device_info "$ip"
            ;;
        5)
            main_menu
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
            nmap_menu
            ;;
    esac
}

# Функции aircrack-ng
aircrack_menu() {
    echo "Выберите действие для aircrack-ng:"
    echo "1) Сканировать доступные сети"
    echo "2) Захватить трафик"
    echo "3) Атаковать сеть"
    echo "4) Вернуться в главное меню"
    read -p "Введите номер вашего выбора: " aircrack_choice

    case $aircrack_choice in
        1)
            echo "Сканируем сети..."
            networks=$(nmcli -t -f SSID dev wifi)

            if [[ -z "$networks" ]]; then
                echo "Нет доступных сетей."
                exit 1
            fi

            for ssid in $networks; do
                echo "Найдена сеть: $ssid"
            done
            ;;
        2)
            read -p "Введите интерфейс для захвата (например, wlan0): " iface
            read -p "Введите имя файла для сохранения: " filename
            echo "Начало захвата трафика..."
            airodump-ng -w "$filename" "$iface"
            ;;
        3)
            read -p "Введите BSSID цели: " bssid
            read -p "Введите имя файла с захваченным трафиком: " filename
            echo "Выполнение атаки на сеть..."
            aircrack-ng -b "$bssid" "$filename"
            ;;
        4)
            main_menu
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
            aircrack_menu
            ;;
    esac
}

# Функции Metasploit
metasploit_menu() {
    echo "Выберите действие для Metasploit:"
    echo "1) Запустить Metasploit консоль"
    echo "2) Провести сканирование уязвимостей"
    echo "3) Эксплуатировать уязвимость"
    echo "4) Вернуться в главное меню"
    read -p "Введите номер вашего выбора: " metasploit_choice

    case $metasploit_choice in
        1)
            echo "Запуск Metasploit консоли..."
            msfconsole
            ;;
        2)
            read -p "Введите IP-адрес цели: " ip
            echo "Проведение сканирования уязвимостей с Metasploit..."
            msfconsole -q -x "db_nmap -sV $ip; exit"
            ;;
        3)
            read -p "Введите путь к эксплоиту: " exploit
            read -p "Введите IP-адрес цели: " ip
            echo "Эксплуатация уязвимости..."
            msfconsole -q -x "use $exploit; set RHOST $ip; exploit; exit"
            ;;
        4)
            main_menu
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
            metasploit_menu
            ;;
    esac
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

# Главное меню
main_menu() {
    echo "Выберите категорию:"
    echo "1) Функции Hydra"
    echo "2) Функции nmap"
    echo "3) Функции aircrack-ng"
    echo "4) Функции Metasploit"
    echo "5) Выйти"
    read -p "Введите номер вашего выбора: " main_choice

    case $main_choice in
        1)
            hydra_menu
            ;;
        2)
            nmap_menu
            ;;
        3)
            aircrack_menu
            ;;
        4)
            metasploit_menu
            ;;
        5)
            echo "Выход из программы."
            exit 0
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, попробуйте еще раз."
            main_menu
            ;;
    esac
}

main_menu
