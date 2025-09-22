"""
Shift class for the Employee Schedule Management System
"""
from enums import Day, ShiftType
from typing import List, TYPE_CHECKING

if TYPE_CHECKING:
    from employee import Employee

class Shift:
    """Class to represent a specific shift"""
    
    MIN_EMPLOYEES_PER_SHIFT = 2
    
    def __init__(self, day: Day, shift_type: ShiftType):
        """Initialize a shift with day and type"""
        self.day = day
        self.type = shift_type
        self.assigned_employees: List['Employee'] = []
    
    def add_employee(self, employee: 'Employee') -> bool:
        """Add an employee to this shift"""
        if employee is None:
            return False
        
        # Check if employee is already assigned to this shift
        if employee in self.assigned_employees:
            return False  # Employee already assigned
        
        self.assigned_employees.append(employee)
        return True
    
    def remove_employee(self, employee: 'Employee') -> bool:
        """Remove an employee from this shift"""
        if employee in self.assigned_employees:
            self.assigned_employees.remove(employee)
            return True
        return False
    
    def is_full(self) -> bool:
        """Check if shift is full (max 5 employees for flexibility)"""
        return len(self.assigned_employees) >= 5
    
    def has_minimum_staff(self) -> bool:
        """Check if shift has minimum required staff"""
        return len(self.assigned_employees) >= self.MIN_EMPLOYEES_PER_SHIFT
    
    def get_employee_count(self) -> int:
        """Get the number of assigned employees"""
        return len(self.assigned_employees)
    
    def get_day(self) -> Day:
        """Get the day of this shift"""
        return self.day
    
    def get_type(self) -> ShiftType:
        """Get the type of this shift"""
        return self.type
    
    def get_assigned_employees(self) -> List['Employee']:
        """Get the list of assigned employees"""
        return self.assigned_employees.copy()  # Return a copy to prevent external modification
    
    def clear_employees(self):
        """Clear all assigned employees"""
        self.assigned_employees.clear()