"===================================================="
"                 RIDE CLASS                         "
"===================================================="
"Abstract base class for all ride types             "
"Demonstrates: Encapsulation, Abstract Methods      "
"===================================================="

Object subclass: Ride [
    | rideID pickupLocation dropoffLocation distance baseFare |
    
    "Class variables"
    Ride class >> initialize [
        "Initialize any class-level data if needed"
    ]
    
    "Constructor - Initialize a new ride instance"
    Ride class >> newWithID: anID pickup: pickup dropoff: dropoff distance: dist [
        | ride |
        ride := self new.
        ride initializeWithID: anID pickup: pickup dropoff: dropoff distance: dist.
        ^ride
    ]
    
    "Instance initialization"
    initializeWithID: anID pickup: pickup dropoff: dropoff distance: dist [
        rideID := anID.
        pickupLocation := pickup.
        dropoffLocation := dropoff.
        distance := dist.
        baseFare := 2.0.  "Base fare for all rides"
    ]
    
    "===================================================="
    "                ENCAPSULATION                       "
    "===================================================="
    "Private instance variables with public accessors   "
    
    "Getter methods (Public interface)"
    getRideID [
        ^rideID
    ]
    
    getPickupLocation [
        ^pickupLocation
    ]
    
    getDropoffLocation [
        ^dropoffLocation
    ]
    
    getDistance [
        ^distance
    ]
    
    getBaseFare [
        ^baseFare
    ]
    
    "Setter methods"
    setDistance: newDistance [
        distance := newDistance
    ]
    
    "===================================================="
    "                POLYMORPHISM                        "
    "===================================================="
    "Abstract method - must be implemented by subclasses"
    
    fare [
        "This is an abstract method that must be implemented by subclasses"
        self subclassResponsibility
    ]
    
    "Virtual method that can be overridden"
    rideDetails [
        Transcript show: '=== Ride Details ==='; nl.
        Transcript show: 'Ride ID: ', rideID printString; nl.
        Transcript show: 'Pickup: ', pickupLocation; nl.
        Transcript show: 'Dropoff: ', dropoffLocation; nl.
        Transcript show: 'Distance: ', distance printString, ' miles'; nl.
        Transcript show: 'Fare: $', self fare printString; nl.
        Transcript show: '==================='; nl.
    ]
    
    "Display method for debugging"
    printOn: aStream [
        aStream nextPutAll: 'Ride(ID: '.
        rideID printOn: aStream.
        aStream nextPutAll: ', '.
        pickupLocation printOn: aStream.
        aStream nextPutAll: ' -> '.
        dropoffLocation printOn: aStream.
        aStream nextPutAll: ')'.
    ]
]