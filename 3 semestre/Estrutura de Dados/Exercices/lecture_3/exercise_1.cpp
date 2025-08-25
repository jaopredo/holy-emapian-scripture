//  Write a function that has as input an integer
//  And as output its sign (negative, positive or if it's 0)

#include <iostream>
using namespace std;

int main() {
    int number;
    cout << "Tell me a number(pls): " << endl;
    cin >> number;
    
    if(number > 0) {
        cout << "The number is positive." << endl;
    } else if(number < 0) {
        cout << "The number is negative" << endl;
    } else {
        cout << "The number is 0." << endl;
    }

    return 0;
}