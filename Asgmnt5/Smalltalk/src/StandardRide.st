"===================================================="
"              STANDARD RIDE CLASS                   "
"===================================================="
"Subclass of Ride - demonstrates inheritance        "
"Implements standard pricing model                   "
"===================================================="

Ride subclass: StandardRide [
    "Class variables for pricing"
    StandardRide class >> ratePerMile [
        ^1.5  "Standard rate per mile"
    ]
    
    "Constructor using inheritance"
    StandardRide class >> newWithID: anID pickup: pickup dropoff: dropoff distance: dist [
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
        "Standard fare calculation: base fare + (distance * rate)"
        ^baseFare + (distance * self class ratePerMile)
    ]
    
    "Override rideDetails to include ride type information"
    rideDetails [
        Transcript show: '=== Standard Ride Details ==='; nl.
        Transcript show: 'Ride ID: ', rideID printString; nl.
        Transcript show: 'Pickup: ', pickupLocation; nl.
        Transcript show: 'Dropoff: ', dropoffLocation; nl.
        Transcript show: 'Distance: ', distance printString, ' miles'; nl.
        Transcript show: 'Rate: $', self class ratePerMile printString, ' per mile'; nl.
        Transcript show: 'Fare: $', self fare printString; nl.
        Transcript show: '============================='; nl.
    ]
    
    "Display method"
    printOn: aStream [
        aStream nextPutAll: 'StandardRide(ID: '.
        rideID printOn: aStream.
        aStream nextPutAll: ', Fare: $'.
        self fare printOn: aStream.
        aStream nextPutAll: ')'.
    ]
]