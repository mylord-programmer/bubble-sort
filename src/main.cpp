#include <iostream>
#include <vector>
#include <limits>

void bubble_sort(std::vector<int>& arr) {
    size_t n = arr.size();
    for (size_t i = 0; i + 1 < n; ++i) {
        for (size_t j = 0; j + 1 < n - i; ++j) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }
}

int main() {
    std::cout << "Enter number of elements (1..100): ";
    int count;
    if (!(std::cin >> count)) {
        std::cerr << "Error: invalid input, integer expected.\n";
        return 1;
    }
    if (count <= 0 || count > 100) {
        std::cerr << "Error: array size must be between 1 and 100.\n";
        return 1;
    }

    std::vector<int> arr(count);
    std::cout << "Enter " << count << " integers:\n";
    for (int i = 0; i < count; ++i) {
        if (!(std::cin >> arr[i])) {
            std::cerr << "Error: invalid integer at position " << i + 1 << ".\n";
            return 1;
        }
    }

    bubble_sort(arr);

    for (size_t i = 0; i < arr.size(); ++i) 
    {
        if (i > 0) std::cout << ' ';
        std::cout << arr[i];
    }
    std::cout << '\n';
    return 0;
}