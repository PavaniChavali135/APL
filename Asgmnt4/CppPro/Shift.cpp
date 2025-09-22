#include "ScheduleManager.h"

// Shift class implementation
Shift::Shift(Day d, ShiftType t) : day(d), type(t) {}

bool Shift::addEmployee(Employee* employee) {
    if (employee == nullptr) {
        return false;
    }
    
    // Check if employee is already assigned to this shift
    auto it = std::find(assignedEmployees.begin(), assignedEmployees.end(), employee);
    if (it != assignedEmployees.end()) {
        return false; // Employee already assigned
    }
    
    assignedEmployees.push_back(employee);
    return true;
}

bool Shift::removeEmployee(Employee* employee) {
    auto it = std::find(assignedEmployees.begin(), assignedEmployees.end(), employee);
    if (it != assignedEmployees.end()) {
        assignedEmployees.erase(it);
        return true;
    }
    return false;
}

bool Shift::isFull() const {
    // For this implementation, we'll consider a shift "full" if it has 5 or more employees
    // This prevents over-assignment while still allowing flexibility
    return assignedEmployees.size() >= 5;
}

bool Shift::hasMinimumStaff() const {
    return assignedEmployees.size() >= MIN_EMPLOYEES_PER_SHIFT;
}

int Shift::getEmployeeCount() const {
    return static_cast<int>(assignedEmployees.size());
}

Day Shift::getDay() const {
    return day;
}

ShiftType Shift::getType() const {
    return type;
}

const std::vector<Employee*>& Shift::getAssignedEmployees() const {
    return assignedEmployees;
}

void Shift::clearEmployees() {
    assignedEmployees.clear();
}