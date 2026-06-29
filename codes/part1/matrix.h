#pragma once
#include <iostream>

//renvoie une matrice NxN remplie avec un coef à choisir pour les valeurs de remplissage
int** matrix(int size);

//renvoie une matrice de zéros NxN
int** null_matrix(int size);

//désalocation de la matrice
void matrix_delete(int** matrix, int size);