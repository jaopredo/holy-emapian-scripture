//Implement a function that receives two pointers
//to integers and swaps the values of the variables.
//In main, create two variables, print their values
//before and after the swap.

#include <iostream>
using namespace std;

void pointer_swapper(int *x1, int *x2) {
    int temp = *x1;  
    *x1 = *x2;      
    *x2 = temp;     
}

int main() {
    int value1, value2;

    cout << "Enter a value for the first variable: ";
    cin >> value1;

    cout << "Enter a value for the second variable: ";
    cin >> value2;

    int *pointer_1 = &value1;
    int *pointer_2 = &value2;

    cout << "\nBefore the swap:" << endl;
    cout << "Value 1: " << *pointer_1 << endl;
    cout << "Value 2: " << *pointer_2 << endl;

    pointer_swapper(pointer_1, pointer_2);

    cout << "\nAfter the swap:" << endl;
    cout << "Value 1: " << *pointer_1 << endl;
    cout << "Value 2: " << *pointer_2 << endl;

    return 0;
}
