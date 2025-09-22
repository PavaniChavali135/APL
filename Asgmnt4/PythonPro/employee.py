"""
Employee class for the Employee Schedule Management System
"""
from enums import Day, ShiftType
from typing import Dict, List

class Employee:
    """Class to store employee information and preferences"""
    
    def __init__(self, name: str):
        """Initialize an employee with a name"""
        self.name = name
        self.preferences: Dict[Day, List[ShiftType]] = {}
        self.assigned_days = 0
    
    def add_preference(self, day: Day, shift: ShiftType):
        """Add a shift preference for a specific day"""
        if day not in self.preferences:
            self.preferences[day] = []
        self.preferences[day].append(shift)
    
    def get_name(self) -> str:
        """Get the employee's name"""
        return self.name
    
    def get_preferences(self) -> Dict[Day, List[ShiftType]]:
        """Get all preferences"""
        return self.preferences
    
    def get_preferences_for_day(self, day: Day) -> List[ShiftType]:
        """Get preferences for a specific day"""
        return self.preferences.get(day, [])
    
    def get_assigned_days(self) -> int:
        """Get the number of assigned days"""
        return self.assigned_days
    
    def increment_assigned_days(self):
        """Increment the number of assigned days"""
        self.assigned_days += 1
    
    def reset_assigned_days(self):
        """Reset the assigned days counter"""
        self.assigned_days = 0
    
    def can_work_more_days(self) -> bool:
        """Check if employee can work more days (max 5 days per week)"""
        return self.assigned_days < 5