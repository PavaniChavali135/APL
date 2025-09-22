#include "ScheduleManager.h"

// Schedule class implementation
Schedule::Schedule() {
    // Initialize all shifts for the week
    for (int d = 0; d <= 6; ++d) {
        Day day = static_cast<Day>(d);
        for (int s = 0; s <= 2; ++s) {
            ShiftType shift = static_cast<ShiftType>(s);
            weeklySchedule[day][shift] = new Shift(day, shift);
        }
    }
}

Schedule::~Schedule() {
    // Clean up dynamically allocated shifts
    for (auto& dayPair : weeklySchedule) {
        for (auto& shiftPair : dayPair.second) {
            delete shiftPair.second;
        }
    }
}

Shift* Schedule::getShift(Day day, ShiftType type) {
    return weeklySchedule[day][type];
}

void Schedule::printSchedule() const {
    printf("\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");
    printf("                    WEEKLY EMPLOYEE SCHEDULE\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");

    std::vector<std::string> dayNames = {
        "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", 
        "FRIDAY", "SATURDAY", "SUNDAY"
    };
    
    std::vector<std::string> shiftNames = {"MORNING", "AFTERNOON", "EVENING"};

    for (int d = 0; d <= 6; ++d) {
        Day day = static_cast<Day>(d);
        printf("\n%s:\n", dayNames[d].c_str());
        for(int i = 0; i < 40; i++) printf("-");
        printf("\n");
        
        for (int s = 0; s <= 2; ++s) {
            ShiftType shiftType = static_cast<ShiftType>(s);
            Shift* shift = weeklySchedule.at(day).at(shiftType);
            
            printf("%-12s: ", shiftNames[s].c_str());
            
            const auto& employees = shift->getAssignedEmployees();
            if (employees.empty()) {
                printf("No employees assigned");
            } else {
                for (size_t i = 0; i < employees.size(); ++i) {
                    if (i > 0) printf(", ");
                    printf("%s", employees[i]->getName().c_str());
                }
                printf(" (%d employee%s)", (int)employees.size(), (employees.size() > 1 ? "s" : ""));
            }
            printf("\n");
        }
    }
    printf("\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");
}

bool Schedule::isEmployeeAssignedOnDay(Employee* employee, Day day) const {
    for (int s = 0; s <= 2; ++s) {
        ShiftType shiftType = static_cast<ShiftType>(s);
        Shift* shift = weeklySchedule.at(day).at(shiftType);
        
        const auto& assignedEmployees = shift->getAssignedEmployees();
        if (std::find(assignedEmployees.begin(), assignedEmployees.end(), employee) != assignedEmployees.end()) {
            return true;
        }
    }
    return false;
}

std::vector<Shift*> Schedule::getShiftsNeedingStaff() const {
    std::vector<Shift*> underStaffedShifts;
    
    for (const auto& dayPair : weeklySchedule) {
        for (const auto& shiftPair : dayPair.second) {
            if (!shiftPair.second->hasMinimumStaff()) {
                underStaffedShifts.push_back(shiftPair.second);
            }
        }
    }
    
    return underStaffedShifts;
}

void Schedule::clearSchedule() {
    for (auto& dayPair : weeklySchedule) {
        for (auto& shiftPair : dayPair.second) {
            shiftPair.second->clearEmployees();
        }
    }
}