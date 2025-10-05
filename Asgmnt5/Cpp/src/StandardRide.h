#ifndef STANDARDRIDE_H
#define STANDARDRIDE_H

#include "Ride.h"

class StandardRide : public Ride {
private:
    static const double RATE_PER_MILE;

public:
    // Constructor
    StandardRide(int id, const std::string& pickup, const std::string& dropoff, double dist);
    
    // Override the virtual fare method (polymorphism)
    double fare() const override;
    
    // Override rideDetails to include ride type
    void rideDetails() const override;
};

#endif // STANDARDRIDE_H