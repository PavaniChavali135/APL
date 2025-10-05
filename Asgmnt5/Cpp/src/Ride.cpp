#include "Ride.h"

Ride::Ride(int id, const std::string& pickup, const std::string& dropoff, double dist)
    : rideID(id), pickupLocation(pickup), dropoffLocation(dropoff), distance(dist), baseFare(2.0) {
}

void Ride::rideDetails() const {
    std::cout << "=== Ride Details ===" << std::endl;
    std::cout << "Ride ID: " << rideID << std::endl;
    std::cout << "Pickup: " << pickupLocation << std::endl;
    std::cout << "Dropoff: " << dropoffLocation << std::endl;
    std::cout << "Distance: " << distance << " miles" << std::endl;
    std::cout << "Fare: $" << fare() << std::endl;
    std::cout << "===================" << std::endl;
}