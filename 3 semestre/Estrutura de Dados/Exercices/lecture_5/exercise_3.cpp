//Enum and Structs
//Create an enum called Position with values Intern, Junior, Mid, and Senior.
//Define a struct Employee that contains a name and a position.
//Create a dynamic array to store n employees and display the values.

#include <iostream>
using namespace std;

enum Position {
    Intern,
    Junior,
    Mid,
    Senior,
};

struct Employee {
    string name;
    Position position;
};

void display_attributes(const Employee& employee) {
    cout << "Name: " << employee.name << ", Position: ";
    switch (employee.position) {
        case Intern: cout << "Intern"; break;
        case Junior: cout << "Junior"; break;
        case Mid: cout << "Mid"; break;
        case Senior: cout << "Senior"; break;
    }
    cout << endl;
}

int main() {
    int number_of_employees;
    cout << "Enter the number of employees to register: ";
    cin >> number_of_employees;
    
    Employee* dynamic_employee_array = new Employee[number_of_employees];

    for(int i = 0; i < number_of_employees; i++) {
        cout << "Enter the name of employee " << (i + 1) << ": ";
        cin.ignore();
        getline(cin, dynamic_employee_array[i].name); 

        int entered_position_number;
        cout << "Enter the number corresponding to the employee's position (Intern = 0, Junior = 1, Mid = 2, Senior = 3): ";
        cin >> entered_position_number;

        if(entered_position_number >= Intern && entered_position_number <= Senior) {
            dynamic_employee_array[i].position = static_cast<Position>(entered_position_number);
        } else {
            cout << "Invalid position number! Try again." << endl;
            i--; 
        }
    }

    cout << "\nThe employee list is:\n";
    for(int i = 0; i < number_of_employees; i++) {
        display_attributes(dynamic_employee_array[i]);
    }

    delete[] dynamic_employee_array;
    return 0;
}