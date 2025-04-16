//Create a program that demonstrates the difference between
//passing a parameter by value, reference, and pointer.
//The program must:

//Define a function for each type of passing.
//Show the effect of each method on the original value of
//the variable.

#include <iostream>
using namespace std;

void ByValue(int x) {
    x += 10;
    cout << "Inside ByValue: " << x << endl;
}

void ByReference(int &x) {
    x += 10;
    cout << "Inside ByReference: " << x << endl;
} 

void ByPointer(int *x) {
    *x += 10;
    cout << "Inside ByPointer: " << *x << endl;
}

int main() {
    int number = 50;
    cout << "Original value: " << number << endl;

    ByValue(number);
    cout << "After ByValue: " << number << endl;

    ByPointer(&number);
    cout << "After ByPointer: " << number << endl;

    ByReference(number);
    cout << "After ByReference: " << number << endl;

    return 0;
}
