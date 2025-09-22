#!/usr/bin/env python3
"""
Employee Schedule Management System - Python Version
Main entry point for the application
"""

from schedule_manager import ScheduleManager

def display_welcome_message():
    """Display the welcome message"""
    print("\n" + "=" * 80)
    print("                 EMPLOYEE SCHEDULE MANAGEMENT SYSTEM")
    print("                        Company Weekly Scheduler")
    print("=" * 80)
    print("\nThis system helps manage employee schedules for a 7-day operation.")
    print("Features:")
    print("- Collect employee shift preferences")
    print("- Assign shifts ensuring no employee works more than 5 days")
    print("- Ensure minimum 2 employees per shift")
    print("- Handle conflicts and automatic assignment when needed")
    print("=" * 80)

def display_menu():
    """Display the main menu"""
    print("\n" + "-" * 50)
    print("MAIN MENU")
    print("-" * 50)
    print("1. Add Employee Preferences")
    print("2. Generate Weekly Schedule")
    print("3. View Current Schedule")
    print("4. Reset Schedule")
    print("5. Exit")
    print("-" * 50)

def main():
    """Main function to run the application"""
    manager = ScheduleManager()
    has_employees = False
    has_schedule = False
    
    display_welcome_message()
    
    while True:
        display_menu()
        choice = input("Enter your choice (1-5): ").strip()
        
        if not choice:
            continue
        
        if choice == '1':
            print("\nCollecting employee preferences...")
            manager.collect_employee_preferences()
            has_employees = True
            has_schedule = False  # Reset schedule flag when new employees are added
        
        elif choice == '2':
            if not has_employees:
                print("\n[WARN] Please add employee preferences first (Option 1).")
                continue
            
            print("\nGenerating weekly schedule...")
            manager.create_schedule()
            has_schedule = True
            
            view_choice = input("\nWould you like to view the generated schedule? (y/n): ").strip().lower()
            if view_choice and view_choice[0] == 'y':
                manager.print_final_schedule()
        
        elif choice == '3':
            if not has_schedule:
                print("\n[WARN] No schedule has been generated yet. Please generate a schedule first (Option 2).")
                continue
            
            manager.print_final_schedule()
        
        elif choice == '4':
            if not has_schedule:
                print("\n[WARN] No schedule to reset.")
                continue
            
            confirm = input("\nAre you sure you want to reset the current schedule? (y/n): ").strip().lower()
            if confirm and confirm[0] == 'y':
                manager.reset_schedule()
                has_schedule = False
                print("Schedule has been reset successfully.")
        
        elif choice == '5':
            print("\n" + "=" * 60)
            print("Thank you for using the Employee Schedule Management System!")
            print("Goodbye!")
            print("=" * 60)
            break
        
        else:
            print("\n[ERROR] Invalid choice. Please enter a number between 1 and 5.")
        
        # Pause before showing menu again
        input("\nPress Enter to continue...")

if __name__ == "__main__":
    main()