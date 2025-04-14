//Create a function that reverses the elements of an
//array using pointers. In main, create an array,
//print the values before and after the reversal.

#include <iostream>
using namespace std;

void array_reverser(int *arr, int size) {
    int *start = arr;            
    int *end = arr + size - 1; 

    while (start < end) {
        int temp = *start;
        *start = *end;
        *end = temp;

        start++;
        end--;
    }
}

int main() {
    int array[] = {1, 2, 3, 4, 5};
    int size = sizeof(array) / sizeof(array[0]);

    cout << "Array before reversal: ";
    for (int i = 0; i < size; i++) {
        cout << array[i] << " ";
    }
    cout << endl;

    array_reverser(array, size);

    cout << "Array after reversal: ";
    for (int i = 0; i < size; i++) {
        cout << array[i] << " ";
    }
    cout << endl;

    return 0;
}
