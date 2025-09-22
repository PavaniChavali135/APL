"""
Schedule class for the Employee Schedule Management System
"""
from enums import Day, ShiftType
from shift import Shift
from typing import Dict, List, TYPE_CHECKING

if TYPE_CHECKING:
    from employee import Employee

class Schedule:
    """Class to manage the weekly schedule"""
    
    def __init__(self):
        """Initialize the weekly schedule with all shifts"""
        self.weekly_schedule: Dict[Day, Dict[ShiftType, Shift]] = {}
        
        # Initialize all shifts for the week
        for day in Day:
            self.weekly_schedule[day] = {}
            for shift_type in ShiftType:
                self.weekly_schedule[day][shift_type] = Shift(day, shift_type)
    
    def get_shift(self, day: Day, shift_type: ShiftType) -> Shift:
        """Get a specific shift"""
        return self.weekly_schedule[day][shift_type]
    
    def print_schedule(self):
        """Print the complete weekly schedule"""
        print("\n" + "=" * 80)
        print("                    WEEKLY EMPLOYEE SCHEDULE")
        print("=" * 80)
        
        day_names = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", 
                    "FRIDAY", "SATURDAY", "SUNDAY"]
        shift_names = ["MORNING", "AFTERNOON", "EVENING"]
        
        for day in Day:
            print(f"\n{day_names[day.value]}:")
            print("-" * 40)
            
            for shift_type in ShiftType:
                shift = self.weekly_schedule[day][shift_type]
                print(f"{shift_names[shift_type.value]:<12}: ", end="")
                
                employees = shift.get_assigned_employees()
                if not employees:
                    print("No employees assigned")
                else:
                    employee_names = [emp.get_name() for emp in employees]
                    print(f"{', '.join(employee_names)} ({len(employees)} employee{'s' if len(employees) > 1 else ''})")
        
        print("\n" + "=" * 80)
    
    def is_employee_assigned_on_day(self, employee: 'Employee', day: Day) -> bool:
        """Check if an employee is already assigned on a specific day"""
        for shift_type in ShiftType:
            shift = self.weekly_schedule[day][shift_type]
            if employee in shift.get_assigned_employees():
                return True
        return False
    
    def get_shifts_needing_staff(self) -> List[Shift]:
        """Get all shifts that need more staff"""
        understaffed_shifts = []
        
        for day_shifts in self.weekly_schedule.values():
            for shift in day_shifts.values():
                if not shift.has_minimum_staff():
                    understaffed_shifts.append(shift)
        
        return understaffed_shifts
    
    def clear_schedule(self):
        """Clear all employee assignments from the schedule"""
        for day_shifts in self.weekly_schedule.values():
            for shift in day_shifts.values():
                shift.clear_employees()