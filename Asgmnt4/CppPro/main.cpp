#include "ScheduleManager.h"

void displayWelcomeMessage() {
    printf("\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");
    printf("                 EMPLOYEE SCHEDULE MANAGEMENT SYSTEM\n");
    printf("                        Company Weekly Scheduler\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");
    printf("\nThis system helps manage employee schedules for a 7-day operation.\n");
    printf("Features:\n");
    printf("- Collect employee shift preferences\n");
    printf("- Assign shifts ensuring no employee works more than 5 days\n");
    printf("- Ensure minimum 2 employees per shift\n");
    printf("- Handle conflicts and automatic assignment when needed\n");
    for(int i = 0; i < 80; i++) printf("=");
    printf("\n");
}

void displayMenu() {
    printf("\n");
    for(int i = 0; i < 50; i++) printf("-");
    printf("\n");
    printf("MAIN MENU\n");
    for(int i = 0; i < 50; i++) printf("-");
    printf("\n");
    printf("1. Add Employee Preferences\n");
    printf("2. Generate Weekly Schedule\n");
    printf("3. View Current Schedule\n");
    printf("4. Reset Schedule\n");
    printf("5. Exit\n");
    for(int i = 0; i < 50; i++) printf("-");
    printf("\n");
    printf("Enter your choice (1-5): ");
}

int main() {
    ScheduleManager manager;
    bool hasEmployees = false;
    bool hasSchedule = false;
    
    displayWelcomeMessage();
    
    while (true) {
        displayMenu();
        
        char choice[10];
        if(fgets(choice, sizeof(choice), stdin) == NULL) {
            continue;
        }
        
        // Remove newline character if present
        choice[strcspn(choice, "\n")] = 0;
        
        if (strlen(choice) == 0) {
            continue;
        }
        
        switch (choice[0]) {
            case '1': {
                printf("\nCollecting employee preferences...\n");
                manager.collectEmployeePreferences();
                hasEmployees = true;
                hasSchedule = false; // Reset schedule flag when new employees are added
                break;
            }
            
            case '2': {
                if (!hasEmployees) {
                    printf("\n[WARN] Please add employee preferences first (Option 1).\n");
                    break;
                }
                
                printf("\nGenerating weekly schedule...\n");
                manager.createSchedule();
                hasSchedule = true;
                
                printf("\nWould you like to view the generated schedule? (y/n): ");
                char viewChoice[10];
                if(fgets(viewChoice, sizeof(viewChoice), stdin) != NULL) {
                    viewChoice[strcspn(viewChoice, "\n")] = 0;
                    if (strlen(viewChoice) > 0 && (viewChoice[0] == 'y' || viewChoice[0] == 'Y')) {
                        manager.printFinalSchedule();
                    }
                }
                break;
            }
            
            case '3': {
                if (!hasSchedule) {
                    printf("\n[WARN] No schedule has been generated yet. Please generate a schedule first (Option 2).\n");
                    break;
                }
                
                manager.printFinalSchedule();
                break;
            }
            
            case '4': {
                if (!hasSchedule) {
                    printf("\n[WARN] No schedule to reset.\n");
                    break;
                }
                
                printf("\nAre you sure you want to reset the current schedule? (y/n): ");
                char confirmChoice[10];
                if(fgets(confirmChoice, sizeof(confirmChoice), stdin) != NULL) {
                    confirmChoice[strcspn(confirmChoice, "\n")] = 0;
                    if (strlen(confirmChoice) > 0 && (confirmChoice[0] == 'y' || confirmChoice[0] == 'Y')) {
                        manager.resetSchedule();
                        hasSchedule = false;
                        printf("Schedule has been reset successfully.\n");
                    }
                }
                break;
            }
            
            case '5': {
                printf("\n");
                for(int i = 0; i < 60; i++) printf("=");
                printf("\n");
                printf("Thank you for using the Employee Schedule Management System!\n");
                printf("Goodbye!\n");
                for(int i = 0; i < 60; i++) printf("=");
                printf("\n");
                return 0;
            }
            
            default: {
                printf("\n[ERROR] Invalid choice. Please enter a number between 1 and 5.\n");
                break;
            }
        }
        
        // Pause before showing menu again
        printf("\nPress Enter to continue...");
        getchar();
    }
    
    return 0;
}