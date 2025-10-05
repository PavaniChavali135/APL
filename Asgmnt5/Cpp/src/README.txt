# Ride Sharing System - C++ OOP Implementation

This project demonstrates the three core Object-Oriented Programming principles in C++: **Encapsulation**, **Inheritance**, and **Polymorphism**.

## Project Structure

src/
    Ride.h              # Base class header
    Ride.cpp            # Base class implementation
    StandardRide.h      # Derived class header
    StandardRide.cpp    # Derived class implementation  
    PremiumRide.h       # Derived class header
    PremiumRide.cpp     # Derived class implementation
    Driver.h            # Driver class header
    Driver.cpp          # Driver class implementation
    Rider.h             # Rider class header
    Rider.cpp           # Rider class implementation
    main.cpp            # Main program with demonstrations
    Compile.bat         # batch file for compilation
    README.md           # This file


## OOP Principles Demonstrated

### 1. **Encapsulation** 🔒
- **Private member variables** in all classes
- **Public getter/setter methods** for controlled access
- **Data hiding** - internal implementation details are hidden
- Examples:
  - `Driver::assignedRides` is private, accessed via `addRide()` and `getAssignedRides()`
  - `Rider::requestedRides` is private, accessed via `requestRide()` and `viewRides()`

### 2. **Inheritance** 🧬
- **Base class**: `Ride` with core ride functionality
- **Derived classes**: 
  - `StandardRide` - standard pricing model
  - `PremiumRide` - premium pricing with luxury surcharge
- **Code reuse** and **hierarchical relationships**

### 3. **Polymorphism** 🎭
- **Virtual functions** in base class (`fare()`, `rideDetails()`)
- **Method overriding** in derived classes
- **Runtime polymorphism** - correct method called based on object type
- **Polymorphic containers** - storing different ride types in same vector



# Compilation Cmd:
cl /EHsc /std:c++11 main.cpp Ride.cpp StandardRide.cpp PremiumRide.cpp Driver.cpp Rider.cpp /Fe:ride_sharing_system.exe



### Core Classes

1. **Ride (Abstract Base Class)**
   - Core attributes: `rideID`, `pickupLocation`, `dropoffLocation`, `distance`, `baseFare`
   - Pure virtual method: `fare()`
   - Virtual method: `rideDetails()`

2. **StandardRide (Derived Class)**
   - Inherits from `Ride`
   - Standard pricing: $1.50 per mile + base fare
   - Overrides `fare()` and `rideDetails()`

3. **PremiumRide (Derived Class)**
   - Inherits from `Ride`
   - Premium pricing: $2.50 per mile + base fare + $5.00 luxury surcharge
   - Overrides `fare()` and `rideDetails()`

4. **Driver Class**
   - Manages assigned rides with encapsulation
   - Methods: `addRide()`, `getDriverInfo()`, `displayRideHistory()`
   - Calculates total earnings

5. **Rider Class**
   - Manages requested rides with encapsulation
   - Methods: `requestRide()`, `viewRides()`, `getRiderInfo()`
   - Calculates total spending

##  Program Output

The program demonstrates:

1. **Encapsulation Examples**
   - Controlled access to private members
   - Data validation in setter methods

2. **Inheritance in Action**
   - Creating objects of derived classes
   - Code reuse from base class

3. **Polymorphism Demonstration**
   - Storing different ride types in same container
   - Runtime method resolution
   - Fare calculation differences

4. **System Simulation**
   - Creating riders and drivers
   - Processing ride requests and assignments
   - Displaying comprehensive system information

## 🔧 Technical Requirements

- **C++ Standard**: C++11 or later
- **Compiler**: Any modern C++ compiler (GCC, Clang, MSVC)
- **Platform**: Cross-platform (Windows, Linux, macOS)

## 📊 Sample Output

The program outputs detailed information showing:
- OOP principle demonstrations
- System entity creation
- Polymorphic method calls
- Ride processing and assignments
- Driver and rider information
- Fare comparisons between ride types

