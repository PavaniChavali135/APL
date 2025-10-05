#ifndef RIDE_H
#define RIDE_H

#include <string>
#include <iostream>

class Ride {
protected:
    int rideID;
    std::string pickupLocation;
    std::string dropoffLocation;
    double distance;
    double baseFare;

public:
    // Constructor
    Ride(int id, const std::string& pickup, const std::string& dropoff, double dist);
    
    // Virtual destructor for proper cleanup in inheritance
    virtual ~Ride() = default;
    
    // Pure virtual method for polymorphic behavior
    virtual double fare() const = 0;
    
    // Virtual method that can be overridden
    virtual void rideDetails() const;
    
    // Getter methods (encapsulation)
    int getRideID() const { return rideID; }
    std::string getPickupLocation() const { return pickupLocation; }
    std::string getDropoffLocation() const { return dropoffLocation; }
    double getDistance() const { return distance; }
    double getBaseFare() const { return baseFare; }
    
    // Setter methods
    void setDistance(double dist) { distance = dist; }
};

#endif // RIDE_H