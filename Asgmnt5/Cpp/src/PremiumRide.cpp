#include "PremiumRide.h"

// Define the static constants
const double PremiumRide::PREMIUM_RATE_PER_MILE = 2.5;
const double PremiumRide::LUXURY_SURCHARGE = 5.0;

PremiumRide::PremiumRide(int id, const std::string& pickup, const std::string& dropoff, double dist)
    : Ride(id, pickup, dropoff, dist) {
}

double PremiumRide::fare() const {
    return baseFare + (distance * PREMIUM_RATE_PER_MILE) + LUXURY_SURCHARGE;
}

void PremiumRide::rideDetails() const {
    std::cout << "=== Premium Ride Details ===" << std::endl;
    std::cout << "Ride ID: " << rideID << std::endl;
    std::cout << "Pickup: " << pickupLocation << std::endl;
    std::cout << "Dropoff: " << dropoffLocation << std::endl;
    std::cout << "Distance: " << distance << " miles" << std::endl;
    std::cout << "Premium Rate: $" << PREMIUM_RATE_PER_MILE << " per mile" << std::endl;
    std::cout << "Luxury Surcharge: $" << LUXURY_SURCHARGE << std::endl;
    std::cout << "Fare: $" << fare() << std::endl;
    std::cout << "============================" << std::endl;
}