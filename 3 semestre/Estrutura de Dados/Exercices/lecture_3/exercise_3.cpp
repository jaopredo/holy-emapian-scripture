//  Write a function that receives an integer
//  and returns true if the number is prime and
//  false otherwise.

#include <iostream>
using namespace std;
#include <cmath>

int prime_verifier(int prime_candidate) {
    if (prime_candidate <= 1) return false;
    if (prime_candidate <= 3) return true;
    if (prime_candidate % 2 == 0 || prime_candidate % 3 == 0) return false;

    int i = 5;
    while (pow(i , 2) <= prime_candidate) {
        if (prime_candidate % i == 0 || prime_candidate % (i + 2) == 0)
            return false;
        i += 6;
    }
    return true;
}

int main() {
    int num;
    cout << "Tell me a number(pls): ";
    cin >> num;
    if (prime_verifier(num)) {
        cout << num << " is a prime number (trust me)." << endl;
    } else {
        cout << num << " is not a prime number (trust me)." << endl;
    }
    return 0;
}
