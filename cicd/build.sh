#!/bin/bash
echo "==== СБОРКА ПРОГРАММЫ ===="
make clean
make bubble-sort

if [ -f bubble-sort ]; then
    echo "Сборка успешна: исполняемый файл bubble-sort создан."
else
    echo "Ошибка: bubble-sort не найден."
    exit 1
fi