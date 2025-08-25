//Implement a function that receives two 2x2 matrices
//and calculates their sum. In main, create two matrices,
//call the function to sum them, and print the resulting
//matrix.

#include <iostream>
using namespace std;

void SumMatrices(int *matrix1, int *matrix2, int *result) {
    for (int i = 0; i < 4; i++) { 
        *(result + i) = *(matrix1 + i) + *(matrix2 + i);
    }
}

void PrintMatrix(int *matrix) {
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            cout << *(matrix + i * 2 + j) << " ";
        }
        cout << endl;
    }
}

int main() {
    int matrix1[2][2] = {{1, 2}, {3, 4}};
    int matrix2[2][2] = {{5, 6}, {7, 8}};
    int result[2][2];

    SumMatrices(&matrix1[0][0], &matrix2[0][0], &result[0][0]);

    cout << "Resulting matrix from the sum:" << endl;
    PrintMatrix(&result[0][0]);

    return 0;
}