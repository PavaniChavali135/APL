#include "Driver.h"

Driver::Driver(int id, const std::string& driverName, double initialRating)
    : driverID(id), name(driverName), rating(initialRating) {
}

void Driver::addRide(std::shared_ptr<Ride> ride) {
    if (ride) {
        assignedRides.push_back(ride);
        std::cout << "Ride " << ride->getRideID() << " assigned to driver " << name << std::endl;
    }
}

void Driver::getDriverInfo() const {
    std::cout << "\n=== Driver Information ===" << std::endl;
    std::cout << "Driver ID: " << driverID << std::endl;
    std::cout << "Name: " << name << std::endl;
    std::cout << "Rating: " << rating << "/5.0" << std::endl;
    std::cout << "Total Rides Completed: " << assignedRides.size() << std::endl;
    std::cout << "Total Earnings: $" << calculateTotalEarnings() << std::endl;
    std::cout << "=========================" << std::endl;
}

std::vector<std::shared_ptr<Ride>> Driver::getAssignedRides() const {
    return assignedRides; // Returns a copy, maintaining encapsulation
}

void Driver::displayRideHistory() const {
    std::cout << "\n=== Ride History for " << name << " ===" << std::endl;
    if (assignedRides.empty()) {
        std::cout << "No rides completed yet." << std::endl;
    } else {
        for (size_t i = 0; i < assignedRides.size(); ++i) {
            std::cout << "\nRide " << (i + 1) << ":" << std::endl;
            assignedRides[i]->rideDetails();
        }
    }
    std::cout << "=================================" << std::endl;
}

void Driver::setRating(double newRating) {
    if (newRating >= 0.0 && newRating <= 5.0) {
        rating = newRating;
    } else {
        std::cout << "Invalid rating. Must be between 0.0 and 5.0" << std::endl;
    }
}

double Driver::calculateTotalEarnings() const {
    double total = 0.0;
    for (const auto& ride : assignedRides) {
        total += ride->fare();
    }
    return total;
}