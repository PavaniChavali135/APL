#include <iostream>
#include <vector>
#include <memory>
#include "Ride.h"
#include "StandardRide.h"
#include "PremiumRide.h"
#include "Driver.h"
#include "Rider.h"

// Function to demonstrate polymorphism with different ride types
void demonstratePolymorphism(const std::vector<std::shared_ptr<Ride>>& rides) {
    std::cout << "\n========================================" << std::endl;
    std::cout << "   DEMONSTRATING POLYMORPHISM" << std::endl;
    std::cout << "========================================" << std::endl;
    
    std::cout << "\nProcessing different ride types polymorphically:" << std::endl;
    
    for (const auto& ride : rides) {
        std::cout << "\n--- Processing Ride ID: " << ride->getRideID() << " ---" << std::endl;
        // Polymorphic calls - the correct overridden methods are called
        ride->rideDetails(); // Virtual method call
        std::cout << "Calculated Fare: $" << ride->fare() << std::endl; // Pure virtual method call
        std::cout << std::endl;
    }
}

// Function to demonstrate encapsulation
void demonstrateEncapsulation() {
    std::cout << "\n========================================" << std::endl;
    std::cout << "   DEMONSTRATING ENCAPSULATION" << std::endl;
    std::cout << "========================================" << std::endl;
    
    std::cout << "\nCreating driver and rider with private member access control:" << std::endl;
    
    Driver driver(101, "Alice Johnson", 4.8);
    Rider rider(201, "Bob Smith");
    
    // These demonstrate encapsulation - we can only access private members through public methods
    std::cout << "\nAccessing private members through public methods:" << std::endl;
    std::cout << "Driver name (via getter): " << driver.getName() << std::endl;
    std::cout << "Driver rating (via getter): " << driver.getRating() << std::endl;
    std::cout << "Rider name (via getter): " << rider.getName() << std::endl;
    
    // Cannot directly access driver.assignedRides or rider.requestedRides - they are private!
    // We must use public methods: addRide(), requestRide(), getAssignedRides(), etc.
}

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << " ***  RIDE SHARING APP  ***" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // Demonstrate encapsulation
    demonstrateEncapsulation();
    
    // Create riders and drivers
    Rider rider1(201, "John Doe");
    Rider rider2(202, "Jane Smith");
    Driver driver1(101, "Mike Wilson", 4.9);
    Driver driver2(102, "Sarah Davis", 4.7);
    
    std::cout << "Created 2 riders and 2 drivers" << std::endl;
    
    // Demonstrate inheritance and polymorphism by creating different ride types
    std::cout << "   CREATING DIFFERENT RIDE TYPES" << std::endl;
    
    // Create different types of rides using inheritance
    std::vector<std::shared_ptr<Ride>> allRides;
    
    // Standard rides
    auto ride1 = std::make_shared<StandardRide>(1001, "Downtown", "Airport", 12.5);
    auto ride2 = std::make_shared<StandardRide>(1002, "Mall", "University", 8.3);
    
    // Premium rides
    auto ride3 = std::make_shared<PremiumRide>(1003, "Hotel", "Business District", 15.0);
    auto ride4 = std::make_shared<PremiumRide>(1004, "Home", "Concert Hall", 6.8);
    
    allRides.push_back(ride1);
    allRides.push_back(ride2);
    allRides.push_back(ride3);
    allRides.push_back(ride4);
    
    std::cout << "Created 2 standard rides and 2 premium rides" << std::endl;
    
    // Demonstrate polymorphism
    demonstratePolymorphism(allRides);
    
    // Simulate ride assignments and requests
   
    // Riders request rides
    std::cout << "\n--- Ride Requests ---" << std::endl;
    rider1.requestRide(ride1);
    rider1.requestRide(ride3);
    rider2.requestRide(ride2);
    rider2.requestRide(ride4);
    
    // Drivers get assigned rides
    std::cout << "\n--- Driver Assignments ---" << std::endl;
    driver1.addRide(ride1);
    driver1.addRide(ride2);
    driver2.addRide(ride3);
    driver2.addRide(ride4);
    
    // Display information using encapsulated methods
    std::cout << "   SYSTEM INFORMATION DISPLAY" << std::endl;

    
    // Display rider information
    rider1.getRiderInfo();
    rider2.getRiderInfo();
    
    // Display driver information
    driver1.getDriverInfo();
    driver2.getDriverInfo();
    
    // Show ride histories
    
    std::cout << "   RIDE HISTORIES" << std::endl;
    
    rider1.viewRides();
    driver1.displayRideHistory();
    
    // Demonstrate fare calculation differences (polymorphism)
    std::cout << "   FARE COMPARISON (POLYMORPHISM)" << std::endl;
    
    double distance = 10.0;
    auto standardRide = std::make_shared<StandardRide>(9999, "Point A", "Point B", distance);
    auto premiumRide = std::make_shared<PremiumRide>(9998, "Point A", "Point B", distance);
    
    std::cout << "\nFor the same " << distance << " mile trip:" << std::endl;
    std::cout << "Standard ride fare: $" << standardRide->fare() << std::endl;
    std::cout << "Premium ride fare: $" << premiumRide->fare() << std::endl;
    std::cout << "Premium surcharge: $" << (premiumRide->fare() - standardRide->fare()) << std::endl;
    
    std::cout << "   DEMO COMPLETED!" << std::endl;
    
    return 0;
}