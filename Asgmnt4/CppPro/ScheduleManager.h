#ifndef SCHEDULE_MANAGER_H
#define SCHEDULE_MANAGER_H

#include <cstdio>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <algorithm>
#include <random>
#include <sstream>
#include <cstring>

// Enums for better type safety
enum class Day {
    MONDAY = 0,
    TUESDAY = 1,
    WEDNESDAY = 2,
    THURSDAY = 3,
    FRIDAY = 4,
    SATURDAY = 5,
    SUNDAY = 6
};

enum class ShiftType {
    MORNING = 0,
    AFTERNOON = 1,
    EVENING = 2
};

// Forward declarations
class Employee;
class Shift;
class Schedule;
class ScheduleManager;

// Employee class to store employee information and preferences
class Employee {
private:
    std::string name;
    std::map<Day, std::vector<ShiftType>> preferences;
    int assignedDays;

public:
    Employee(const std::string& empName);
    
    void addPreference(Day day, ShiftType shift);
    std::string getName() const;
    const std::map<Day, std::vector<ShiftType>>& getPreferences() const;
    std::vector<ShiftType> getPreferencesForDay(Day day) const;
    int getAssignedDays() const;
    void incrementAssignedDays();
    void resetAssignedDays();
    bool canWorkMoreDays() const;
};

// Shift class to represent a specific shift
class Shift {
private:
    Day day;
    ShiftType type;
    std::vector<Employee*> assignedEmployees;
    static const int MIN_EMPLOYEES_PER_SHIFT = 2;

public:
    Shift(Day d, ShiftType t);
    
    bool addEmployee(Employee* employee);
    bool removeEmployee(Employee* employee);
    bool isFull() const;
    bool hasMinimumStaff() const;
    int getEmployeeCount() const;
    Day getDay() const;
    ShiftType getType() const;
    const std::vector<Employee*>& getAssignedEmployees() const;
    void clearEmployees();
};

// Schedule class to manage the weekly schedule
class Schedule {
private:
    std::map<Day, std::map<ShiftType, Shift*>> weeklySchedule;

public:
    Schedule();
    ~Schedule();
    
    Shift* getShift(Day day, ShiftType type);
    void printSchedule() const;
    bool isEmployeeAssignedOnDay(Employee* employee, Day day) const;
    std::vector<Shift*> getShiftsNeedingStaff() const;
    void clearSchedule();
};

// Main ScheduleManager class with scheduling logic
class ScheduleManager {
private:
    std::vector<Employee> employees;
    Schedule* schedule;
    std::mt19937 randomGenerator;

    // Helper methods
    std::string dayToString(Day day) const;
    std::string shiftTypeToString(ShiftType type) const;
    Day stringToDay(const std::string& dayStr) const;
    ShiftType stringToShiftType(const std::string& shiftStr) const;
    void assignBasedOnPreferences();
    void fillUnderStaffedShifts();
    std::vector<Employee*> getAvailableEmployees(Day day) const;

public:
    ScheduleManager();
    ~ScheduleManager();
    
    void addEmployee(const Employee& employee);
    void createSchedule();
    void printFinalSchedule() const;
    void collectEmployeePreferences();
    void resetSchedule();
    
    // Input validation helpers
    bool isValidDay(const std::string& dayStr) const;
    bool isValidShiftType(const std::string& shiftStr) const;
};

#endif // SCHEDULE_MANAGER_H