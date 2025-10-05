"===================================================="
"               PREMIUM RIDE CLASS                   "
"===================================================="
"Subclass of Ride - demonstrates inheritance        "
"Implements premium pricing with luxury surcharge   "
"===================================================="

Ride subclass: PremiumRide [
    "Class variables for premium pricing"
    PremiumRide class >> premiumRatePerMile [
        ^2.5  "Premium rate per mile"
    ]
    
    PremiumRide class >> luxurySurcharge [
        ^5.0  "Additional luxury surcharge"
    ]
    
    "Constructor using inheritance"
    PremiumRide class >> newWithID: anID pickup: pickup dropoff: dropoff distance: dist [
        | ride |
        ride := self new.
        ride initializeWithID: anID pickup: pickup dropoff: dropoff distance: dist.
        ^ride
    ]
    
    "===================================================="
    "                POLYMORPHISM                        "
    "===================================================="
    "Override the abstract fare method from parent class"
    
    fare [
        "Premium fare calculation: base fare + (distance * premium rate) + luxury surcharge"
        ^baseFare + (distance * self class premiumRatePerMile) + self class luxurySurcharge
    ]
    
    "Override rideDetails to include premium ride information"
    rideDetails [
        Transcript show: '=== Premium Ride Details ==='; nl.
        Transcript show: 'Ride ID: ', rideID printString; nl.
        Transcript show: 'Pickup: ', pickupLocation; nl.
        Transcript show: 'Dropoff: ', dropoffLocation; nl.
        Transcript show: 'Distance: ', distance printString, ' miles'; nl.
        Transcript show: 'Premium Rate: $', self class premiumRatePerMile printString, ' per mile'; nl.
        Transcript show: 'Luxury Surcharge: $', self class luxurySurcharge printString; nl.
        Transcript show: 'Fare: $', self fare printString; nl.
        Transcript show: '============================'; nl.
    ]
    
    "Display method"
    printOn: aStream [
        aStream nextPutAll: 'PremiumRide(ID: '.
        rideID printOn: aStream.
        aStream nextPutAll: ', Fare: $'.
        self fare printOn: aStream.
        aStream nextPutAll: ')'.
    ]
]