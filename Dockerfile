FROM ubuntu:24.04

# Устанавливаем зависимости времени выполнения
RUN apt-get update && apt-get install -y prometheus-cpp-dev libcivetweb-dev

# Копируем исполняемый файл
COPY bubble-sort /usr/local/bin/

# Открываем порты
EXPOSE 8081

# Команда по умолчанию
CMD ["bubble-sort"]