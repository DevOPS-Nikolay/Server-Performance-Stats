#!/bin/bash

#!/bin/bash

# Отображение версии операционной системы
echo "=== Версия ОС ==="
cat /etc/os-release | grep -E '^PRETTY_NAME' | awk -F '="' '{print $2}' | sed 's/"$//'

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
    total_clean=$(echo $total | sed "s/[^0-9.]//g")
    used_clean=$(echo $used | sed "s/[^0-9.]//g")
    free_clean=$(echo $free | sed "s/[^0-9.]//g")

    # Вычисление процента использования
    total_bytes=$(free -b | awk '/^Mem:/ {print $2}')
    used_bytes=$(free -b | awk '/^Mem:/ {print $3}')
    percent=$(awk -v used="$used_bytes" -v total="$total_bytes" 'BEGIN {printf "%.2f", (used/total)*100}')

    echo "Всего: $total, Использовано: $used, Свободно: $free (${percent}% занято)"
}

# Функция для отображения использования диска
disk_usage() {
    echo "=== Использование диска ==="
    if df -h --total > /dev/null 2>&1; then
        df -h --total | awk '/^total/ {printf "Всего: %s, Использовано: %s, Свободно: %s (%s занято)\n", $2, $3, $4, $5}'
    else
        df -h | awk 'NR>1 {used+=$3; free+=$4; total+=$2} END {printf "Всего: %.1fG, Использовано: %.1fG, Свободно: %.1fG (%.2f%% занято)\n", total, used, free, (used/total)*100}'
    fi
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
    total_clean=$(echo $total | sed "s/[^0-9.]//g")
    used_clean=$(echo $used | sed "s/[^0-9.]//g")
    free_clean=$(echo $free | sed "s/[^0-9.]//g")

    # Вычисление процента использования
    total_bytes=$(free -b | awk '/^Mem:/ {print $2}')
    used_bytes=$(free -b | awk '/^Mem:/ {print $3}')
    percent=$(awk -v used="$used_bytes" -v total="$total_bytes" 'BEGIN {printf "%.2f", (used/total)*100}')

    echo "Всего: $total, Использовано: $used, Свободно: $free (${percent}% занято)"
}

# Функция для отображения использования диска
disk_usage() {
    echo "=== Использование диска ==="
    if df -h --total > /dev/null 2>&1; then
        df -h --total | awk '/^total/ {printf "Всего: %s, Использовано: %s, Свободно: %s (%s занято)\n", $2, $3, $4, $5}'
    else
        df -h | awk 'NR>1 {used+=$3; free+=$4; total+=$2} END {printf "Всего: %.1fG, Использовано: %.1fG, Свободно: %.1fG (%.2f%% занято)\n", total, used, free, (used/total)*100}'
    fi
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
