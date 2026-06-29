#include <cuda_runtime.h>
#include <iostream>
#include <chrono>

#define WIDTH 2000

// Multiplication matricielle GPU
__global__ void matrixMulKernel(float* A, float* B, float* C, int width)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    int totalThreads = gridDim.x * blockDim.x;
    int totalElements = width * width;

    for (int idx = tid; idx < totalElements; idx += totalThreads)
    {
        int row = idx / width;
        int col = idx % width;

        float sum = 0;

        for (int k = 0; k < width; k++)
        {
            sum += A[row * width + k] *
                B[k * width + col];
        }

        C[idx] = sum;
    }
}

// Remplissage matrice
void fillMatrix(float* M, std::string name, int width)
{
    int coeff;

    std::cout << "Coefficient matrice "
        << name << " : ";

    std::cin >> coeff;

    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < width; j++)
        {
            M[i * width + j] = i * j * coeff;
        }
    }
}

// Affichage matrice
void printMatrix(float* M, std::string name, int width)
{
    std::cout << "\nMatrice " << name << " :\n";

    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < width; j++)
        {
            std::cout << M[i * width + j] << " ";
        }
        std::cout << "\n";
    }
}


int main()
{
    int blocks;
    int threads;

    std::cout << "Nombre de blocs : ";
    std::cin >> blocks;

    std::cout << "Nombre de threads par bloc : ";
    std::cin >> threads;

    int N = WIDTH * WIDTH;
    int size = N * sizeof(float);

    // Matrices CPU
    float* A = (float*)malloc(size);
    float* B = (float*)malloc(size);
    float* C = (float*)malloc(size);

    // Matrices GPU
    float* Agpu;
    float* Bgpu;
    float* Cgpu;

    cudaMalloc((void**)&Agpu, size);
    cudaMalloc((void**)&Bgpu, size);
    cudaMalloc((void**)&Cgpu, size);

    fillMatrix(A, "A", WIDTH);
    fillMatrix(B, "B", WIDTH);

    auto totalStart =
        std::chrono::high_resolution_clock::now();

    cudaMemcpy(
        Agpu,
        A,
        size,
        cudaMemcpyHostToDevice);

    cudaMemcpy(
        Bgpu,
        B,
        size,
        cudaMemcpyHostToDevice);

    auto gpuStart =
        std::chrono::high_resolution_clock::now();

    matrixMulKernel << <blocks, threads >> > (
        Agpu,
        Bgpu,
        Cgpu,
        WIDTH);

    cudaDeviceSynchronize();

    auto gpuEnd =
        std::chrono::high_resolution_clock::now();

    cudaMemcpy(
        C,
        Cgpu,
        size,
        cudaMemcpyDeviceToHost);

    auto totalEnd =
        std::chrono::high_resolution_clock::now();

    auto gpuTime =
        std::chrono::duration_cast
        <std::chrono::microseconds>
        (gpuEnd - gpuStart);

    auto totalTime =
        std::chrono::duration_cast
        <std::chrono::microseconds>
        (totalEnd - totalStart);

    std::cout << "\nTemps GPU seul : "
        << gpuTime.count()
        << " us\n";

    std::cout << "Temps total : "
        << totalTime.count()
        << " us\n";

    // Affichage seulement pour petites matrices
    if (WIDTH <= 10)
    {
        printMatrix(A, "A", WIDTH);
        printMatrix(B, "B", WIDTH);
        printMatrix(C, "C = A x B", WIDTH);
    }

    cudaFree(Agpu);
    cudaFree(Bgpu);
    cudaFree(Cgpu);

    free(A);
    free(B);
    free(C);

    return 0;
}