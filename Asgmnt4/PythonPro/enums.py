"""
Enums for the Employee Schedule Management System
"""
from enum import Enum, IntEnum

class Day(IntEnum):
    """Enumeration for days of the week"""
    MONDAY = 0
    TUESDAY = 1
    WEDNESDAY = 2
    THURSDAY = 3
    FRIDAY = 4
    SATURDAY = 5
    SUNDAY = 6

class ShiftType(IntEnum):
    """Enumeration for shift types"""
    MORNING = 0
    AFTERNOON = 1
    EVENING = 2