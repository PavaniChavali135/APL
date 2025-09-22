#include "ScheduleManager.h"

// ScheduleManager class implementation
ScheduleManager::ScheduleManager() : randomGenerator(std::random_device{}()) {
    schedule = new Schedule();
}

ScheduleManager::~ScheduleManager() {
    delete schedule;
}

void ScheduleManager::addEmployee(const Employee& employee) {
    employees.push_back(employee);
}

std::string ScheduleManager::dayToString(Day day) const {
    switch (day) {
        case Day::MONDAY: return "Monday";
        case Day::TUESDAY: return "Tuesday";
        case Day::WEDNESDAY: return "Wednesday";
        case Day::THURSDAY: return "Thursday";
        case Day::FRIDAY: return "Friday";
        case Day::SATURDAY: return "Saturday";
        case Day::SUNDAY: return "Sunday";
        default: return "Unknown";
    }
}

std::string ScheduleManager::shiftTypeToString(ShiftType type) const {
    switch (type) {
        case ShiftType::MORNING: return "Morning";
        case ShiftType::AFTERNOON: return "Afternoon";
        case ShiftType::EVENING: return "Evening";
        default: return "Unknown";
    }
}

Day ScheduleManager::stringToDay(const std::string& dayStr) const {
    std::string lowerDay = dayStr;
    std::transform(lowerDay.begin(), lowerDay.end(), lowerDay.begin(), ::tolower);
    
    if (lowerDay == "monday" || lowerDay == "mon" || lowerDay == "1") return Day::MONDAY;
    if (lowerDay == "tuesday" || lowerDay == "tue" || lowerDay == "2") return Day::TUESDAY;
    if (lowerDay == "wednesday" || lowerDay == "wed" || lowerDay == "3") return Day::WEDNESDAY;
    if (lowerDay == "thursday" || lowerDay == "thu" || lowerDay == "4") return Day::THURSDAY;
    if (lowerDay == "friday" || lowerDay == "fri" || lowerDay == "5") return Day::FRIDAY;
    if (lowerDay == "saturday" || lowerDay == "sat" || lowerDay == "6") return Day::SATURDAY;
    if (lowerDay == "sunday" || lowerDay == "sun" || lowerDay == "7") return Day::SUNDAY;
    
    return Day::MONDAY; // Default fallback
}

ShiftType ScheduleManager::stringToShiftType(const std::string& shiftStr) const {
    std::string lowerShift = shiftStr;
    std::transform(lowerShift.begin(), lowerShift.end(), lowerShift.begin(), ::tolower);
    
    if (lowerShift == "morning" || lowerShift == "morn" || lowerShift == "m" || lowerShift == "1") 
        return ShiftType::MORNING;
    if (lowerShift == "afternoon" || lowerShift == "aft" || lowerShift == "a" || lowerShift == "2") 
        return ShiftType::AFTERNOON;
    if (lowerShift == "evening" || lowerShift == "eve" || lowerShift == "e" || lowerShift == "3") 
        return ShiftType::EVENING;
    
    return ShiftType::MORNING; // Default fallback
}

bool ScheduleManager::isValidDay(const std::string& dayStr) const {
    std::string lowerDay = dayStr;
    std::transform(lowerDay.begin(), lowerDay.end(), lowerDay.begin(), ::tolower);
    
    return (lowerDay == "monday" || lowerDay == "mon" || lowerDay == "1" ||
            lowerDay == "tuesday" || lowerDay == "tue" || lowerDay == "2" ||
            lowerDay == "wednesday" || lowerDay == "wed" || lowerDay == "3" ||
            lowerDay == "thursday" || lowerDay == "thu" || lowerDay == "4" ||
            lowerDay == "friday" || lowerDay == "fri" || lowerDay == "5" ||
            lowerDay == "saturday" || lowerDay == "sat" || lowerDay == "6" ||
            lowerDay == "sunday" || lowerDay == "sun" || lowerDay == "7");
}

bool ScheduleManager::isValidShiftType(const std::string& shiftStr) const {
    std::string lowerShift = shiftStr;
    std::transform(lowerShift.begin(), lowerShift.end(), lowerShift.begin(), ::tolower);
    
    return (lowerShift == "morning" || lowerShift == "morn" || lowerShift == "m" || lowerShift == "1" ||
            lowerShift == "afternoon" || lowerShift == "aft" || lowerShift == "a" || lowerShift == "2" ||
            lowerShift == "evening" || lowerShift == "eve" || lowerShift == "e" || lowerShift == "3");
}

void ScheduleManager::assignBasedOnPreferences() {
    printf("\nAssigning shifts based on employee preferences...\n");
    
    // Reset assigned days for all employees
    for (auto& employee : employees) {
        employee.resetAssignedDays();
    }
    
    // Try to assign employees to their preferred shifts
    for (auto& employee : employees) {
        const auto& preferences = employee.getPreferences();
        
        for (const auto& dayPref : preferences) {
            Day day = dayPref.first;
            const auto& shiftPrefs = dayPref.second;
            
            // Skip if employee already worked this day or has reached max days
            if (schedule->isEmployeeAssignedOnDay(&employee, day) || !employee.canWorkMoreDays()) {
                continue;
            }
            
            // Try to assign to preferred shifts for this day
            bool assigned = false;
            for (ShiftType preferredShift : shiftPrefs) {
                Shift* shift = schedule->getShift(day, preferredShift);
                
                if (!shift->isFull() && shift->addEmployee(&employee)) {
                    employee.incrementAssignedDays();
                    assigned = true;
                    printf("  [OK] Assigned %s to %s %s\n", 
                           employee.getName().c_str(), 
                           dayToString(day).c_str(), 
                           shiftTypeToString(preferredShift).c_str());
                    break; // Only one shift per day per employee
                }
            }
            
            if (assigned) {
                continue; // Move to next day
            }
            
            // If preferred shifts are full, try other shifts on the same day
            for (int s = 0; s <= 2; ++s) {
                ShiftType anyShift = static_cast<ShiftType>(s);
                
                // Skip if this was already a preferred shift
                if (std::find(shiftPrefs.begin(), shiftPrefs.end(), anyShift) != shiftPrefs.end()) {
                    continue;
                }
                
                Shift* shift = schedule->getShift(day, anyShift);
                if (!shift->isFull() && shift->addEmployee(&employee)) {
                    employee.incrementAssignedDays();
                    printf("  [ALT] Assigned %s to %s %s (alternative shift - preferred was full)\n", 
                           employee.getName().c_str(), 
                           dayToString(day).c_str(), 
                           shiftTypeToString(anyShift).c_str());
                    break;
                }
            }
        }
    }
}

std::vector<Employee*> ScheduleManager::getAvailableEmployees(Day day) const {
    std::vector<Employee*> available;
    
    for (const auto& employee : employees) {
        // Check if employee can work more days and is not already assigned this day
        if (employee.canWorkMoreDays() && !schedule->isEmployeeAssignedOnDay(const_cast<Employee*>(&employee), day)) {
            available.push_back(const_cast<Employee*>(&employee));
        }
    }
    
    return available;
}

void ScheduleManager::fillUnderStaffedShifts() {
    printf("\nFilling under-staffed shifts...\n");
    
    auto underStaffedShifts = schedule->getShiftsNeedingStaff();
    
    if (underStaffedShifts.empty()) {
        printf("All shifts have minimum staffing requirements met.\n");
        return;
    }
    
    for (Shift* shift : underStaffedShifts) {
        Day day = shift->getDay();
        ShiftType shiftType = shift->getType();
        int needed = 2 - shift->getEmployeeCount();
        
        printf("  [WARN] %s %s needs %d more employee(s)\n", 
               dayToString(day).c_str(), 
               shiftTypeToString(shiftType).c_str(), 
               needed);
        
        auto availableEmployees = getAvailableEmployees(day);
        
        if (availableEmployees.empty()) {
            printf("    [ERROR] No available employees for %s\n", dayToString(day).c_str());
            continue;
        }
        
        // Shuffle available employees for random assignment
        std::shuffle(availableEmployees.begin(), availableEmployees.end(), randomGenerator);
        
        int assigned = 0;
        for (Employee* employee : availableEmployees) {
            if (assigned >= needed) break;
            
            if (shift->addEmployee(employee)) {
                employee->incrementAssignedDays();
                assigned++;
                printf("    [OK] Randomly assigned %s to %s %s\n", 
                       employee->getName().c_str(), 
                       dayToString(day).c_str(), 
                       shiftTypeToString(shiftType).c_str());
            }
        }
        
        if (assigned < needed) {
            printf("    [WARN] Could only assign %d out of %d needed employees\n", assigned, needed);
        }
    }
}

void ScheduleManager::createSchedule() {
    printf("\n");
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    printf("CREATING WEEKLY SCHEDULE\n");
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    
    if (employees.empty()) {
        printf("No employees to schedule!\n");
        return;
    }
    
    // Clear any existing schedule
    schedule->clearSchedule();
    
    // Step 1: Assign based on preferences
    assignBasedOnPreferences();
    
    // Step 2: Fill under-staffed shifts
    fillUnderStaffedShifts();
    
    printf("\nSchedule creation completed!\n");
}

void ScheduleManager::printFinalSchedule() const {
    schedule->printSchedule();
    
    // Print summary statistics
    printf("\nSCHEDULE SUMMARY:\n");
    for(int i = 0; i < 40; i++) printf("-");
    printf("\n");
    
    for (const auto& employee : employees) {
        printf("%s: %d days assigned\n", 
               employee.getName().c_str(), 
               employee.getAssignedDays());
    }
    
    // Check for under-staffed shifts
    auto underStaffed = schedule->getShiftsNeedingStaff();
    if (!underStaffed.empty()) {
        printf("\nWARNING: The following shifts are still under-staffed:\n");
        for (Shift* shift : underStaffed) {
            printf("  - %s %s (%d/2 minimum)\n", 
                   dayToString(shift->getDay()).c_str(),
                   shiftTypeToString(shift->getType()).c_str(),
                   shift->getEmployeeCount());
        }
    }
}

void ScheduleManager::collectEmployeePreferences() {
    printf("\n");
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    printf("EMPLOYEE SCHEDULE PREFERENCE COLLECTION\n");
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    
    printf("\nInstructions:\n");
    printf("- Days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday\n");
    printf("  (or use abbreviations: Mon, Tue, Wed, Thu, Fri, Sat, Sun)\n");
    printf("  (or use numbers: 1=Monday, 2=Tuesday, ..., 7=Sunday)\n");
    printf("- Shifts: Morning, Afternoon, Evening\n");
    printf("  (or use abbreviations: M, A, E)\n");
    printf("  (or use numbers: 1=Morning, 2=Afternoon, 3=Evening)\n");
    printf("- Type 'done' when finished adding preferences for an employee\n");
    printf("- Type 'finish' to complete all employee entries\n");
    
    employees.clear(); // Clear any existing employees
    
    while (true) {
        printf("\n");
        for(int i = 0; i < 40; i++) printf("-");
        printf("\n");
        printf("Enter employee name (or 'finish' to complete): ");
        
        char employeeName[256];
        if(fgets(employeeName, sizeof(employeeName), stdin) == NULL) {
            continue;
        }
        
        // Remove newline character if present
        employeeName[strcspn(employeeName, "\n")] = 0;
        
        if (strlen(employeeName) == 0) {
            continue;
        }
        
        if (strcmp(employeeName, "finish") == 0 || strcmp(employeeName, "FINISH") == 0) {
            break;
        }
        
        Employee newEmployee{std::string(employeeName)};
        printf("\nCollecting preferences for %s:\n", employeeName);
        
        while (true) {
            printf("\nEnter day and shift preference (e.g., 'Monday Morning' or 'done' to finish): ");
            
            char input[256];
            if(fgets(input, sizeof(input), stdin) == NULL) {
                continue;
            }
            
            // Remove newline character if present
            input[strcspn(input, "\n")] = 0;
            
            if (strlen(input) == 0) {
                continue;
            }
            
            if (strcmp(input, "done") == 0 || strcmp(input, "DONE") == 0) {
                break;
            }
            
            // Parse input - expect "day shift" format
            char dayStr[50], shiftStr[50];
            if (sscanf(input, "%49s %49s", dayStr, shiftStr) != 2) {
                printf("  [ERROR] Invalid format. Please use 'Day Shift' format (e.g., 'Monday Morning')\n");
                continue;
            }
            
            if (!isValidDay(std::string(dayStr))) {
                printf("  [ERROR] Invalid day: %s\n", dayStr);
                printf("    Valid days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday\n");
                continue;
            }
            
            if (!isValidShiftType(std::string(shiftStr))) {
                printf("  [ERROR] Invalid shift: %s\n", shiftStr);
                printf("    Valid shifts: Morning, Afternoon, Evening\n");
                continue;
            }
            
            Day day = stringToDay(std::string(dayStr));
            ShiftType shift = stringToShiftType(std::string(shiftStr));
            
            newEmployee.addPreference(day, shift);
            printf("  [OK] Added preference: %s %s\n", 
                   dayToString(day).c_str(), 
                   shiftTypeToString(shift).c_str());
        }
        
        if (newEmployee.getPreferences().empty()) {
            printf("Warning: %s has no preferences. Adding anyway...\n", employeeName);
        }
        
        employees.push_back(newEmployee);
        printf("Employee %s added successfully!\n", employeeName);
    }
    
    if (employees.empty()) {
        printf("\nNo employees entered. Please restart the program to add employees.\n");
        return;
    }
    
    printf("\n");
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    printf("PREFERENCE COLLECTION COMPLETED\n");
    printf("Total employees: %d\n", (int)employees.size());
    for(int i = 0; i < 60; i++) printf("=");
    printf("\n");
    
    // Display summary of collected preferences
    printf("\nSUMMARY OF EMPLOYEE PREFERENCES:\n");
    for(int i = 0; i < 40; i++) printf("-");
    printf("\n");
    
    for (const auto& employee : employees) {
        printf("\n%s:\n", employee.getName().c_str());
        const auto& prefs = employee.getPreferences();
        
        if (prefs.empty()) {
            printf("  No specific preferences\n");
        } else {
            for (const auto& dayPref : prefs) {
                printf("  %s: ", dayToString(dayPref.first).c_str());
                for (size_t i = 0; i < dayPref.second.size(); ++i) {
                    if (i > 0) printf(", ");
                    printf("%s", shiftTypeToString(dayPref.second[i]).c_str());
                }
                printf("\n");
            }
        }
    }
}

void ScheduleManager::resetSchedule() {
    schedule->clearSchedule();
    for (auto& employee : employees) {
        employee.resetAssignedDays();
    }
}