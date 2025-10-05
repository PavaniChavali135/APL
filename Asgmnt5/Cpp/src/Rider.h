#ifndef RIDER_H
#define RIDER_H

#include <string>
#include <vector>
#include <memory>
#include <iostream>
#include "Ride.h"

class Rider {
private:
    int riderID;
    std::string name;
    std::vector<std::shared_ptr<Ride>> requestedRides; // Encapsulated - private member

public:
    // Constructor
    Rider(int id, const std::string& riderName);
    
    // Destructor
    ~Rider() = default;
    
    // Public methods to interact with private requestedRides (Encapsulation)
    void requestRide(std::shared_ptr<Ride> ride);
    void viewRides() const;
    std::vector<std::shared_ptr<Ride>> getRequestedRides() const;
    void getRiderInfo() const;
    
    // Getter methods
    int getRiderID() const { return riderID; }
    std::string getName() const { return name; }
    int getTotalRides() const { return requestedRides.size(); }
    
    // Calculate total spending
    double calculateTotalSpending() const;
};

#endif // RIDER_H