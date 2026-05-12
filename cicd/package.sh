#!/bin/bash
echo "==== СБОРКА DEB-ПАКЕТА ===="
make deb

if [ -f build/bubble-sort-pkg.deb ]; then
    echo "Пакет успешно создан: build/bubble-sort-pkg.deb"
else
    echo "Ошибка: пакет не был создан."
    exit 1
fi