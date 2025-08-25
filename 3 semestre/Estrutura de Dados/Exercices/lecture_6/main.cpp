#include <iostream>
#include "conversion.h"

int main() {
    std::cout <<"10C in F is: " << converters::convert_celsius_to_fahrenheit(10) << std::endl;
    std::cout << "1F in C is: " << converters::convert_fahrenheit_to_celsius(1) << std::endl;
    return 0;
}