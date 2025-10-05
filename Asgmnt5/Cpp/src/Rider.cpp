#include "Rider.h"

Rider::Rider(int id, const std::string& riderName)
    : riderID(id), name(riderName) {
}

void Rider::requestRide(std::shared_ptr<Ride> ride) {
    if (ride) {
        requestedRides.push_back(ride);
        std::cout << "Ride " << ride->getRideID() << " requested by rider " << name << std::endl;
    }
}

void Rider::viewRides() const {
    std::cout << "\n=== Ride History for " << name << " ===" << std::endl;
    if (requestedRides.empty()) {
        std::cout << "No rides requested yet." << std::endl;
    } else {
        for (size_t i = 0; i < requestedRides.size(); ++i) {
            std::cout << "\nRide " << (i + 1) << ":" << std::endl;
            requestedRides[i]->rideDetails();
        }
    }
    std::cout << "===================================" << std::endl;
}

std::vector<std::shared_ptr<Ride>> Rider::getRequestedRides() const {
    return requestedRides; // Returns a copy, maintaining encapsulation
}

void Rider::getRiderInfo() const {
    std::cout << "\n=== Rider Information ===" << std::endl;
    std::cout << "Rider ID: " << riderID << std::endl;
    std::cout << "Name: " << name << std::endl;
    std::cout << "Total Rides Requested: " << requestedRides.size() << std::endl;
    std::cout << "Total Spending: $" << calculateTotalSpending() << std::endl;
    std::cout << "=========================" << std::endl;
}

double Rider::calculateTotalSpending() const {
    double total = 0.0;
    for (const auto& ride : requestedRides) {
        total += ride->fare();
    }
    return total;
}