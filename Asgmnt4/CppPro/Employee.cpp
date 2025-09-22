#include "ScheduleManager.h"

// Employee class implementation
Employee::Employee(const std::string& empName) : name(empName), assignedDays(0) {}

void Employee::addPreference(Day day, ShiftType shift) {
    preferences[day].push_back(shift);
}

std::string Employee::getName() const {
    return name;
}

const std::map<Day, std::vector<ShiftType>>& Employee::getPreferences() const {
    return preferences;
}

std::vector<ShiftType> Employee::getPreferencesForDay(Day day) const {
    auto it = preferences.find(day);
    if (it != preferences.end()) {
        return it->second;
    }
    return std::vector<ShiftType>();
}

int Employee::getAssignedDays() const {
    return assignedDays;
}

void Employee::incrementAssignedDays() {
    assignedDays++;
}

void Employee::resetAssignedDays() {
    assignedDays = 0;
}

bool Employee::canWorkMoreDays() const {
    return assignedDays < 5; // Maximum 5 days per week
}