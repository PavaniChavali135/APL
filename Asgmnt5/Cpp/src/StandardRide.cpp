#include "StandardRide.h"

// Define the static constant
const double StandardRide::RATE_PER_MILE = 1.5;

StandardRide::StandardRide(int id, const std::string& pickup, const std::string& dropoff, double dist)
    : Ride(id, pickup, dropoff, dist) {
}

double StandardRide::fare() const {
    return baseFare + (distance * RATE_PER_MILE);
}

void StandardRide::rideDetails() const {
    std::cout << "=== Standard Ride Details ===" << std::endl;
    std::cout << "Ride ID: " << rideID << std::endl;
    std::cout << "Pickup: " << pickupLocation << std::endl;
    std::cout << "Dropoff: " << dropoffLocation << std::endl;
    std::cout << "Distance: " << distance << " miles" << std::endl;
    std::cout << "Rate: $" << RATE_PER_MILE << " per mile" << std::endl;
    std::cout << "Fare: $" << fare() << std::endl;
    std::cout << "=============================" << std::endl;
}