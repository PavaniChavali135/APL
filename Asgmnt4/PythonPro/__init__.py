"""
Employee Schedule Management System - Python Package

A Python implementation of an employee scheduling system that manages
weekly shift assignments based on employee preferences while ensuring
business constraints are met.

Modules:
- enums: Day and ShiftType enumerations
- employee: Employee class for storing preferences and assignments
- shift: Shift class for managing individual shift assignments
- schedule: Schedule class for coordinating weekly shifts
- schedule_manager: Main scheduling logic and user interface
- main: Application entry point

Usage:
    python main.py

Author: Converted from C++ original
Version: 1.0.0
"""

__version__ = "1.0.0"
__author__ = "Schedule Management Team"

# Import main classes for package-level access
from .enums import Day, ShiftType
from .employee import Employee
from .shift import Shift
from .schedule import Schedule
from .schedule_manager import ScheduleManager

__all__ = ['Day', 'ShiftType', 'Employee', 'Shift', 'Schedule', 'ScheduleManager']