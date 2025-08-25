#include "conversion.h"
#include <iostream>

namespace converters {

    double convert_celsius_to_fahrenheit(double celsius) {
        double result_as_fahrenheit = (celsius * (9.0/5.0)) + 32;
        return result_as_fahrenheit;
    }

    double convert_fahrenheit_to_celsius(double fahrenheit) {
        double result_as_celsius = (fahrenheit - 32) * (5.0/9.0);
        return result_as_celsius;
    }
}