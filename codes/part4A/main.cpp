#include <iostream>
#include <chrono>
#include "tools.h"
#include <vector>
#include <thread>
#include "matrix.h"

int integer;
int n_thread;

int** matrix_a;
int** matrix_b;
int** matrix_c;

//calcule le produit matriciel de a et b, fournit la réponse dans c
void product(int i) {
    for (int j = i; j < integer*integer; j+= n_thread) {
        int e = j % integer;
        int f = j / integer;
        for (int k = 0; k < integer; k++) {
            matrix_c[e][f] += matrix_a[e][k] * matrix_b[k][f];
        }
    }
}

int main()
{
    std::cout << "Choisir le nombre de threads : ";
    std::cin >> n_thread;

    std::cout << "Choisir la taille des matrices : ";
    std::cin >> integer;

    matrix_a = matrix(integer);
    matrix_b = matrix(integer);
    matrix_c = null_matrix(integer);

    std::cout << "\n\nMatrice A :";
    print_matrix(matrix_a, integer);

    std::cout << "\n\nMatrice B :";
    print_matrix(matrix_b, integer);

    std::chrono::steady_clock::time_point start, end;
    start = std::chrono::steady_clock::now();

    std::vector<std::thread> workers;

    for (int i = 0; i < n_thread; i++) {
        workers.emplace_back(product, i);
    }
    for (int i = 0; i < n_thread; ++i) workers[i].join();

    end = std::chrono::steady_clock::now();
    std::chrono::steady_clock::duration duration = end - start;

    std::cout << "\n\nMatrice C :";
    print_matrix(matrix_c, integer);

    std::cout << "\nTemps requis (microseconds) : " << std::chrono::duration_cast<std::chrono::microseconds>(duration).count();

    matrix_delete(matrix_a, integer);
    matrix_delete(matrix_b, integer);
    matrix_delete(matrix_c, integer);
}
