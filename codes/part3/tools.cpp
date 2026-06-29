#include "tools.h"


//affiche une matrice
void print_matrix(int** matrix, int size) {
    if (size < 100) {
        std::cout << "\n\n";
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                std::cout << matrix[i][j] << " ";
            }
            std::cout << "\n";
        }
    }
    else {
        std::cout << "\nMatrice trop grande\n";
    }
}
