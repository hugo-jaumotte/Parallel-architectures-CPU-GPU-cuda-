#include "matrix.h"

//renvoie une matrice NxN remplie avec un coef à choisir pour les valeurs de remplissage
int** matrix(int size) {
    int** matrix;
    matrix = new int* [size];

    int coef;
    std::cout << "Choisir le coef : ";
    std::cin >> coef;

    for (int i = 0; i < size; i++) {
        matrix[i] = new int[size];
        for (int j = 0; j < size; j++) {
            matrix[i][j] = i * j * coef;
        }
    }
    return matrix;
}

//renvoie une matrice de zéros NxN
int** null_matrix(int size) {
    int** matrix;
    matrix = new int* [size];

    for (int i = 0; i < size; i++) {
        matrix[i] = new int[size];
        for (int j = 0; j < size; j++) {
            matrix[i][j] = 0;
        }
    }
    return matrix;
}

//désalocation de la matrice
void matrix_delete(int** matrix, int size) {
    for (int i = 0; i < size; i++) {
        delete[] matrix[i];
    }
    delete[] matrix;
}