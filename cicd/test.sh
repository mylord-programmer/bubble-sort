#!/bin/bash
echo "==== ТЕСТИРОВАНИЕ ПРОГРАММЫ ===="

# Проверка работоспособности бинарника
if [ ! -f ./bubble-sort ]; then
    echo "Ошибка: файл bubble-sort отсутствует. Сначала выполните сборку."
    exit 1
fi

# Тест 1: обычный массив
result=$(echo -e "5\n3 8 1 4 6" | ./bubble-sort | tail -n1)
expected="1 3 4 6 8"
echo "Тест 1: ввод 5, 3 8 1 4 6 -> $result"
if [ "$result" != "$expected" ]; then
    echo "Тест 1 провален: ожидалось '$expected', получено '$result'"
    exit 1
fi

# Тест 2: одно число
result=$(echo -e "1\n42" | ./bubble-sort | tail -n1)
expected="42"
echo "Тест 2: ввод 1, 42 -> $result"
if [ "$result" != "$expected" ]; then
    echo "Тест 2 провален"
    exit 1
fi

# Тест 3: уже отсортированный массив
result=$(echo -e "4\n1 2 3 4" | ./bubble-sort | tail -n1)
expected="1 2 3 4"
echo "Тест 3: ввод 4, 1 2 3 4 -> $result"
if [ "$result" != "$expected" ]; then
    echo "Тест 3 провален"
    exit 1
fi

# Тест 4: обратный порядок
result=$(echo -e "4\n4 3 2 1" | ./bubble-sort | tail -n1)
expected="1 2 3 4"
echo "Тест 4: ввод 4, 4 3 2 1 -> $result"
if [ "$result" != "$expected" ]; then
    echo "Тест 4 провален"
    exit 1
fi

# Тест 5: отрицательные числа
result=$(echo -e "3\n-5 0 2" | ./bubble-sort | tail -n1)
expected="-5 0 2"
echo "Тест 5: ввод 3, -5 0 2 -> $result"
if [ "$result" != "$expected" ]; then
    echo "Тест 5 провален"
    exit 1
fi

# Тест 6: неверный размер (0) - программа должна завершиться с ошибкой
echo "Тест 6: попытка ввести размер 0"
if echo -e "0\n" | ./bubble-sort; then
    echo "Тест 6 провален: программа приняла недопустимый размер 0"
    exit 1
else
    echo "Тест 6 пройден: программа отклонила размер 0"
fi

# Тест 7: размер > 100
echo "Тест 7: попытка ввести размер 101"
if echo -e "101\n$(seq -s ' ' 1 101)" | ./bubble-sort; then
    echo "Тест 7 провален: программа приняла размер > 100"
    exit 1
else
    echo "Тест 7 пройден: программа отклонила размер > 100"
fi

echo "Все тесты пройдены успешно."