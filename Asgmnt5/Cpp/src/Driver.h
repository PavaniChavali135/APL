#ifndef DRIVER_H
#define DRIVER_H

#include <string>
#include <vector>
#include <memory>
#include <iostream>
#include "Ride.h"

class Driver {
private:
    int driverID;
    std::string name;
    double rating;
    std::vector<std::shared_ptr<Ride>> assignedRides; // Encapsulated - private member

public:
    // Constructor
    Driver(int id, const std::string& driverName, double initialRating = 5.0);
    
    // Destructor
    ~Driver() = default;
    
    // Public methods to interact with private assignedRides (Encapsulation)
    void addRide(std::shared_ptr<Ride> ride);
    void getDriverInfo() const;
    std::vector<std::shared_ptr<Ride>> getAssignedRides() const;
    void displayRideHistory() const;
    
    // Getter methods
    int getDriverID() const { return driverID; }
    std::string getName() const { return name; }
    double getRating() const { return rating; }
    int getTotalRides() const { return assignedRides.size(); }
    
    // Setter methods
    void setRating(double newRating);
    
    // Calculate total earnings
    double calculateTotalEarnings() const;
};

#endif // DRIVER_H