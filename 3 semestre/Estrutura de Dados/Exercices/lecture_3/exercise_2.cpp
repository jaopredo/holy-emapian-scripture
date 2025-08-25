//  Write a function that receives an array of integers
//  and the size of the array, and returns the sum of all
//  the elements in the array.

#include <iostream>
using namespace std;

int sum_arr(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

int main() {
    int size;
    cout << "Tell me the array size (now): " << endl;
    cin >> size;

    int arr[size];

    cout << "Tell me the array's elements (now): " << endl;
    for (int i = 0; i < size; i++) { 
        cin >> arr[i]; 
    }

    int result = sum_arr(arr, size); 
    cout << "The sum is: " << result << endl; 

    return 0;
}