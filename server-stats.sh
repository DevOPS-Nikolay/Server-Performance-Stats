#!/bin/bash

# Отображение версии операционной системы
echo "=== Версия ОС ==="
grep -E '^PRETTY_NAME' /etc/os-release | awk -F '="' '{print $2}' | sed 's/"$//'

# Функция для отображения общей информации о ЦП
cpu_usage() {
    echo "=== Общая загрузка ЦП ==="
    if command -v mpstat > /dev/null; then
        mpstat | awk '/all/ {printf "Загрузка ЦП: %.2f%%\n", 100 - $NF}'
    else
        echo "Команда 'mpstat' не найдена. Установите пакет 'sysstat'."
    fi
}

# Функция для отображения использования памяти
memory_usage() {
    echo "=== Использование памяти ==="
    read total used free <<< $(free -h | awk '/^Mem:/ {print $2, $3, $4}')

    # Вычисление процента использования
    total_bytes=$(free -b | awk '/^Mem:/ {print $2}')
    used_bytes=$(free -b | awk '/^Mem:/ {print $3}')
    percent=$(awk -v used="$used_bytes" -v total="$total_bytes" 'BEGIN {printf "%.2f", (used/total)*100}')

    echo "Всего: $total, Использовано: $used, Свободно: $free (${percent}% занято)"
}

# Функция для отображения использования диска
disk_usage() {
    echo "=== Использование диска ==="
    df -h --total | awk '/^total/ {printf "Всего: %s, Использовано: %s, Свободно: %s (%s занято)\n", $2, $3, $4, $5}'
}

# Функция для отображения топ-5 процессов по использованию ЦП
top_cpu_processes() {
    echo "=== Топ-5 процессов по загрузке ЦП ==="
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR>1 {printf "PID: %s, Процесс: %s, ЦП: %.1f%%\n", $1, $2, $3}'
}

# Функция для отображения топ-5 процессов по использованию памяти
top_memory_processes() {
    echo "=== Топ-5 процессов по загрузке памяти ==="
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR>1 {printf "PID: %s, Процесс: %s, Память: %.1f%%\n", $1, $2, $3}'
}

# Запуск функций
cpu_usage
memory_usage
disk_usage
top_cpu_processes
top_memory_processes
