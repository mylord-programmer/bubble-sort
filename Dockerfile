FROM ubuntu:24.04

# Копируем deb-пакет внутрь образа
COPY bubble-sort-pkg.deb /tmp/bubble-sort-pkg.deb

# Устанавливаем пакет и сразу чистим за собой
RUN apt-get update && \
    apt-get install -y /tmp/bubble-sort-pkg.deb && \
    rm /tmp/bubble-sort-pkg.deb

# При запуске контейнера сразу запускаем программу
ENTRYPOINT ["bubble-sort"]
