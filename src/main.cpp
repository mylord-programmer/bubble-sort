#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
#include <cstring>
#include <thread>
#include <prometheus/counter.h>
#include <prometheus/registry.h>
#include <civetweb.h>

// Глобальный указатель на счётчик
prometheus::Counter* g_sort_counter = nullptr;

void bubble_sort(std::vector<int>& arr) {
    size_t n = arr.size();
    for (size_t i = 0; i + 1 < n; ++i)
        for (size_t j = 0; j + 1 < n - i; ++j)
            if (arr[j] > arr[j + 1])
                std::swap(arr[j], arr[j + 1]);
}

// Обработчик CivetWeb (правильная сигнатура)
int handler(struct mg_connection *conn) {
    const struct mg_request_info *ri = mg_get_request_info(conn);

    // POST /sort – принимаем числа, возвращаем отсортированный массив
    if (strcmp(ri->request_method, "POST") == 0 && strcmp(ri->local_uri, "/sort") == 0) {
        char post_data[1024];
        int len = mg_read(conn, post_data, sizeof(post_data) - 1);
        if (len <= 0) {
            mg_send_http_error(conn, 400, "Empty body");
            return 1;
        }
        post_data[len] = '\0';
        std::istringstream iss(post_data);
        std::vector<int> arr;
        int num;
        while (iss >> num) arr.push_back(num);

        bubble_sort(arr);

        std::ostringstream oss;
        for (size_t i = 0; i < arr.size(); ++i) {
            if (i) oss << ' ';
            oss << arr[i];
        }
        std::string resp = oss.str();

        // Увеличиваем счётчик запросов
        if (g_sort_counter) g_sort_counter->Increment();

        mg_send_http_ok(conn, "text/plain", resp.length());
        mg_write(conn, resp.c_str(), resp.length());
        return 1;
    }

    // GET /metrics – отдаём метрики в формате Prometheus
    if (strcmp(ri->request_method, "GET") == 0 && strcmp(ri->local_uri, "/metrics") == 0) {
        std::ostringstream metrics;
        metrics << "# HELP sort_requests_total Total number of sort requests\n";
        metrics << "# TYPE sort_requests_total counter\n";
        if (g_sort_counter)
            metrics << "sort_requests_total " << g_sort_counter->Value() << "\n";
        else
            metrics << "sort_requests_total 0\n";
        std::string body = metrics.str();
        mg_send_http_ok(conn, "text/plain; version=0.0.4", body.length());
        mg_write(conn, body.c_str(), body.length());
        return 1;
    }

    return 0; // не обработано
}

int main() {
    // Создаём реестр и семейство счётчиков
    auto registry = std::make_shared<prometheus::Registry>();
    auto& counter_family = prometheus::BuildCounter()
        .Name("sort_requests_total")
        .Help("Total number of sort requests")
        .Register(*registry);
    
    // Добавляем конкретный счётчик (без меток)
    g_sort_counter = &counter_family.Add({});

    // Запускаем HTTP-сервер на порту 8081
    const char *options[] = {
        "listening_ports", "8081",
        "num_threads", "2",
        nullptr
    };
    mg_callbacks callbacks;
    std::memset(&callbacks, 0, sizeof(callbacks));
    callbacks.begin_request = handler;

    mg_context *ctx = mg_start(&callbacks, nullptr, options);
    if (!ctx) {
        std::cerr << "Cannot start HTTP server" << std::endl;
        return 1;
    }
    std::cout << "Service listening on port 8081 (sort: POST /sort, metrics: GET /metrics)" << std::endl;

    // Бесконечное ожидание
    while (true) {
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    mg_stop(ctx);
    return 0;
}