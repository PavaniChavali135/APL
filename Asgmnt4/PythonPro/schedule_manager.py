"""
ScheduleManager class for the Employee Schedule Management System
"""
import random
from typing import List
from enums import Day, ShiftType
from employee import Employee
from schedule import Schedule

class ScheduleManager:
    """Main class to manage employee scheduling logic"""
    
    def __init__(self):
        """Initialize the schedule manager"""
        self.employees: List[Employee] = []
        self.schedule = Schedule()
    
    def add_employee(self, employee: Employee):
        """Add an employee to the system"""
        self.employees.append(employee)
    
    def day_to_string(self, day: Day) -> str:
        """Convert Day enum to string"""
        day_map = {
            Day.MONDAY: "Monday",
            Day.TUESDAY: "Tuesday", 
            Day.WEDNESDAY: "Wednesday",
            Day.THURSDAY: "Thursday",
            Day.FRIDAY: "Friday",
            Day.SATURDAY: "Saturday",
            Day.SUNDAY: "Sunday"
        }
        return day_map.get(day, "Unknown")
    
    def shift_type_to_string(self, shift_type: ShiftType) -> str:
        """Convert ShiftType enum to string"""
        shift_map = {
            ShiftType.MORNING: "Morning",
            ShiftType.AFTERNOON: "Afternoon",
            ShiftType.EVENING: "Evening"
        }
        return shift_map.get(shift_type, "Unknown")
    
    def string_to_day(self, day_str: str) -> Day:
        """Convert string to Day enum"""
        day_str = day_str.lower()
        
        day_map = {
            "monday": Day.MONDAY, "mon": Day.MONDAY, "1": Day.MONDAY,
            "tuesday": Day.TUESDAY, "tue": Day.TUESDAY, "2": Day.TUESDAY,
            "wednesday": Day.WEDNESDAY, "wed": Day.WEDNESDAY, "3": Day.WEDNESDAY,
            "thursday": Day.THURSDAY, "thu": Day.THURSDAY, "4": Day.THURSDAY,
            "friday": Day.FRIDAY, "fri": Day.FRIDAY, "5": Day.FRIDAY,
            "saturday": Day.SATURDAY, "sat": Day.SATURDAY, "6": Day.SATURDAY,
            "sunday": Day.SUNDAY, "sun": Day.SUNDAY, "7": Day.SUNDAY
        }
        
        return day_map.get(day_str, Day.MONDAY)  # Default fallback
    
    def string_to_shift_type(self, shift_str: str) -> ShiftType:
        """Convert string to ShiftType enum"""
        shift_str = shift_str.lower()
        
        shift_map = {
            "morning": ShiftType.MORNING, "morn": ShiftType.MORNING, 
            "m": ShiftType.MORNING, "1": ShiftType.MORNING,
            "afternoon": ShiftType.AFTERNOON, "aft": ShiftType.AFTERNOON,
            "a": ShiftType.AFTERNOON, "2": ShiftType.AFTERNOON,
            "evening": ShiftType.EVENING, "eve": ShiftType.EVENING,
            "e": ShiftType.EVENING, "3": ShiftType.EVENING
        }
        
        return shift_map.get(shift_str, ShiftType.MORNING)  # Default fallback
    
    def is_valid_day(self, day_str: str) -> bool:
        """Check if day string is valid"""
        day_str = day_str.lower()
        valid_days = {"monday", "mon", "1", "tuesday", "tue", "2", 
                     "wednesday", "wed", "3", "thursday", "thu", "4",
                     "friday", "fri", "5", "saturday", "sat", "6",
                     "sunday", "sun", "7"}
        return day_str in valid_days
    
    def is_valid_shift_type(self, shift_str: str) -> bool:
        """Check if shift string is valid"""
        shift_str = shift_str.lower()
        valid_shifts = {"morning", "morn", "m", "1", "afternoon", "aft", 
                       "a", "2", "evening", "eve", "e", "3"}
        return shift_str in valid_shifts
    
    def assign_based_on_preferences(self):
        """Assign employees to shifts based on their preferences"""
        print("\nAssigning shifts based on employee preferences...")
        
        # Reset assigned days for all employees
        for employee in self.employees:
            employee.reset_assigned_days()
        
        # Try to assign employees to their preferred shifts
        for employee in self.employees:
            preferences = employee.get_preferences()
            
            for day, shift_prefs in preferences.items():
                # Skip if employee already worked this day or has reached max days
                if (self.schedule.is_employee_assigned_on_day(employee, day) or 
                    not employee.can_work_more_days()):
                    continue
                
                # Try to assign to preferred shifts for this day
                assigned = False
                for preferred_shift in shift_prefs:
                    shift = self.schedule.get_shift(day, preferred_shift)
                    
                    if not shift.is_full() and shift.add_employee(employee):
                        employee.increment_assigned_days()
                        assigned = True
                        print(f"  [OK] Assigned {employee.get_name()} to {self.day_to_string(day)} {self.shift_type_to_string(preferred_shift)}")
                        break  # Only one shift per day per employee
                
                if assigned:
                    continue  # Move to next day
                
                # If preferred shifts are full, try other shifts on the same day
                for shift_type in ShiftType:
                    # Skip if this was already a preferred shift
                    if shift_type in shift_prefs:
                        continue
                    
                    shift = self.schedule.get_shift(day, shift_type)
                    if not shift.is_full() and shift.add_employee(employee):
                        employee.increment_assigned_days()
                        print(f"  [ALT] Assigned {employee.get_name()} to {self.day_to_string(day)} {self.shift_type_to_string(shift_type)} (alternative shift - preferred was full)")
                        break
    
    def get_available_employees(self, day: Day) -> List[Employee]:
        """Get employees available to work on a specific day"""
        available = []
        
        for employee in self.employees:
            # Check if employee can work more days and is not already assigned this day
            if (employee.can_work_more_days() and 
                not self.schedule.is_employee_assigned_on_day(employee, day)):
                available.append(employee)
        
        return available
    
    def fill_understaffed_shifts(self):
        """Fill shifts that don't have minimum staffing"""
        print("\nFilling under-staffed shifts...")
        
        understaffed_shifts = self.schedule.get_shifts_needing_staff()
        
        if not understaffed_shifts:
            print("All shifts have minimum staffing requirements met.")
            return
        
        for shift in understaffed_shifts:
            day = shift.get_day()
            shift_type = shift.get_type()
            needed = 2 - shift.get_employee_count()
            
            print(f"  [WARN] {self.day_to_string(day)} {self.shift_type_to_string(shift_type)} needs {needed} more employee(s)")
            
            available_employees = self.get_available_employees(day)
            
            if not available_employees:
                print(f"    [ERROR] No available employees for {self.day_to_string(day)}")
                continue
            
            # Shuffle available employees for random assignment
            random.shuffle(available_employees)
            
            assigned = 0
            for employee in available_employees:
                if assigned >= needed:
                    break
                
                if shift.add_employee(employee):
                    employee.increment_assigned_days()
                    assigned += 1
                    print(f"    [OK] Randomly assigned {employee.get_name()} to {self.day_to_string(day)} {self.shift_type_to_string(shift_type)}")
            
            if assigned < needed:
                print(f"    [WARN] Could only assign {assigned} out of {needed} needed employees")
    
    def create_schedule(self):
        """Create the weekly schedule"""
        print("\n" + "=" * 60)
        print("CREATING WEEKLY SCHEDULE")
        print("=" * 60)
        
        if not self.employees:
            print("No employees to schedule!")
            return
        
        # Clear any existing schedule
        self.schedule.clear_schedule()
        
        # Step 1: Assign based on preferences
        self.assign_based_on_preferences()
        
        # Step 2: Fill under-staffed shifts
        self.fill_understaffed_shifts()
        
        print("\nSchedule creation completed!")
    
    def print_final_schedule(self):
        """Print the final schedule with summary"""
        self.schedule.print_schedule()
        
        # Print summary statistics
        print("\nSCHEDULE SUMMARY:")
        print("-" * 40)
        
        for employee in self.employees:
            print(f"{employee.get_name()}: {employee.get_assigned_days()} days assigned")
        
        # Check for under-staffed shifts
        understaffed = self.schedule.get_shifts_needing_staff()
        if understaffed:
            print("\nWARNING: The following shifts are still under-staffed:")
            for shift in understaffed:
                print(f"  - {self.day_to_string(shift.get_day())} {self.shift_type_to_string(shift.get_type())} ({shift.get_employee_count()}/2 minimum)")
    
    def collect_employee_preferences(self):
        """Collect employee preferences through user input"""
        print("\n" + "=" * 60)
        print("EMPLOYEE SCHEDULE PREFERENCE COLLECTION")
        print("=" * 60)
        
        print("\nInstructions:")
        print("- Days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday")
        print("  (or use abbreviations: Mon, Tue, Wed, Thu, Fri, Sat, Sun)")
        print("  (or use numbers: 1=Monday, 2=Tuesday, ..., 7=Sunday)")
        print("- Shifts: Morning, Afternoon, Evening")
        print("  (or use abbreviations: M, A, E)")
        print("  (or use numbers: 1=Morning, 2=Afternoon, 3=Evening)")
        print("- Type 'done' when finished adding preferences for an employee")
        print("- Type 'finish' to complete all employee entries")
        
        self.employees.clear()  # Clear any existing employees
        
        while True:
            print("\n" + "-" * 40)
            employee_name = input("Enter employee name (or 'finish' to complete): ").strip()
            
            if not employee_name:
                continue
            
            if employee_name.lower() == "finish":
                break
            
            new_employee = Employee(employee_name)
            print(f"\nCollecting preferences for {employee_name}:")
            
            while True:
                preference_input = input("\nEnter day and shift preference (e.g., 'Monday Morning' or 'done' to finish): ").strip()
                
                if not preference_input:
                    continue
                
                if preference_input.lower() == "done":
                    break
                
                # Parse input - expect "day shift" format
                parts = preference_input.split()
                if len(parts) != 2:
                    print("  [ERROR] Invalid format. Please use 'Day Shift' format (e.g., 'Monday Morning')")
                    continue
                
                day_str, shift_str = parts
                
                if not self.is_valid_day(day_str):
                    print(f"  [ERROR] Invalid day: {day_str}")
                    print("    Valid days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday")
                    continue
                
                if not self.is_valid_shift_type(shift_str):
                    print(f"  [ERROR] Invalid shift: {shift_str}")
                    print("    Valid shifts: Morning, Afternoon, Evening")
                    continue
                
                day = self.string_to_day(day_str)
                shift = self.string_to_shift_type(shift_str)
                
                new_employee.add_preference(day, shift)
                print(f"  [OK] Added preference: {self.day_to_string(day)} {self.shift_type_to_string(shift)}")
            
            if not new_employee.get_preferences():
                print(f"Warning: {employee_name} has no preferences. Adding anyway...")
            
            self.employees.append(new_employee)
            print(f"Employee {employee_name} added successfully!")
        
        if not self.employees:
            print("\nNo employees entered. Please restart the program to add employees.")
            return
        
        print("\n" + "=" * 60)
        print("PREFERENCE COLLECTION COMPLETED")
        print(f"Total employees: {len(self.employees)}")
        print("=" * 60)
        
        # Display summary of collected preferences
        print("\nSUMMARY OF EMPLOYEE PREFERENCES:")
        print("-" * 40)
        
        for employee in self.employees:
            print(f"\n{employee.get_name()}:")
            prefs = employee.get_preferences()
            
            if not prefs:
                print("  No specific preferences")
            else:
                for day, shift_prefs in prefs.items():
                    shift_names = [self.shift_type_to_string(shift) for shift in shift_prefs]
                    print(f"  {self.day_to_string(day)}: {', '.join(shift_names)}")
    
    def reset_schedule(self):
        """Reset the current schedule"""
        self.schedule.clear_schedule()
        for employee in self.employees:
            employee.reset_assigned_days()