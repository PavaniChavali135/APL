// A simple class to represent a Student on the heap
#include <iostream>
#include <string>
#include <memory> // For std::unique_ptr
class Student
{
public:
    int id;
    std::string name;

    Student(int i, std::string n) : id(i), name(n)
    {
        std::cout << "Student " << name << " (ID: " << id << ") enrolled." << std::endl;
    }
    ~Student() // Destructor
    {
        std::cout << "Student " << name << " (ID: " << id << ") graduated." << std::endl;
    }
};

void manual_leak_student()
{

    Student *myStudent = new Student(31, "Pavani");
    std::cout << "  Student " << myStudent->name << " left without graduating." << std::endl;
}

void manual_no_leak_student()
{
    Student *myStudent = new Student(23, "vini");
    std::cout << "  Manually graduating student " << myStudent->name << "." << std::endl;
    delete myStudent;
}

void smart_pointer_management_student()
{
    // std::unique_ptr manages the memory automatically
    std::unique_ptr<Student> myStudent = std::make_unique<Student>(10, "Aru");
    std::cout << "  Student " << myStudent->name << " will graduate automatically." << std::endl;
}

int main()
{
    std::cout << "Example for Memory Leak" << std::endl;
    manual_leak_student();

    std::cout << "\nCorrect Manual Management" << std::endl;
    manual_no_leak_student();

    std::cout << "\nSmartpointer Modern C++" << std::endl;
    smart_pointer_management_student();

    return 0;
}
