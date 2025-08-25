//Manipulating Dynamic Arrays
//Create a function that receives a number n and returns a dynamic array filled with numbers from 1 to n.
//Properly free the memory in main.

#include <iostream>
using namespace std;

int* filler(int n) {
    int* array_up_to_n = new int[n];
    for (int i = 0; i < n; i++) { 
        array_up_to_n[i] = i + 1;
    }
    return array_up_to_n;
}

int main() {
    int n;
    cout << "Enter a number: " << endl;
    cin >> n;
    
    int* result_array = filler(n);

    cout << "Filled Array: " << endl;
    for (int i = 0; i < n; i++) {
        cout << result_array[i] << endl;
    }
    
    delete[] result_array;
    return 0;
}
