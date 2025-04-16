//Creating a Dynamic Struct
//Create a struct called Student with the attributes name and grade.
//Dynamically allocate an object of this struct and fill in the values.
//Display the values and properly free the memory.

#include <iostream>
using namespace std;

struct Student {
    float grade;
    string name;
};

Student* createStudent(float grade, string name) {
    Student* newStudent = new Student;
    newStudent->name = name;
    newStudent->grade = grade;
    return newStudent;
}

int main() {
    Student* specialStudent = createStudent(0 , "ShaolinMatadorDePorco");
    cout << "Student: " << specialStudent->name << " | Grade: " << specialStudent->grade << endl;
    delete specialStudent;
    return 0;
}