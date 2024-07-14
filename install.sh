#!/bin/bash

# Проверка прав пользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Запустите скрипт с правами суперпользователя (sudo)."
    exit 1
fi

# Обновление списка пакетов
echo "Обновление списка пакетов..."
apt update

# Установка необходимых инструментов
echo "Установка необходимых пакетов..."
apt install -y nmap hydra git

# Клонирование репозитория
echo "Клонирование репозитория..."
git clone https://github.com/MrGengarnenok/HydraGengar.git ~/HydraGengar

# Перемещение скриптов в нужную директорию
echo "Перемещение скриптов..."
mkdir -p ~/hydragengar/scripts
mv ~/HydraGengar/scripts/* ~/hydragengar/scripts/

# Удаление клонированного репозитория
rm -rf ~/HydraGengar

echo "Установка завершена!"
