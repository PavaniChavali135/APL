#ifndef PREMIUMRIDE_H
#define PREMIUMRIDE_H

#include "Ride.h"

class PremiumRide : public Ride {
private:
    static const double PREMIUM_RATE_PER_MILE;
    static const double LUXURY_SURCHARGE;

public:
    // Constructor
    PremiumRide(int id, const std::string& pickup, const std::string& dropoff, double dist);
    
    // Override the virtual fare method (polymorphism)
    double fare() const override;
    
    // Override rideDetails to include ride type
    void rideDetails() const override;
};

#endif // PREMIUMRIDE_H