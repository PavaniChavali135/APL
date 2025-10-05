"===================================================="
"           RIDE SHARING SYSTEM DEMO                 "
"===================================================="
"Demonstrates all three OOP principles:             "
"1. Encapsulation - Private data with public access "
"2. Inheritance - Base class and subclasses         "
"3. Polymorphism - Virtual methods and overriding   "
"===================================================="

"Load all necessary classes"
FileStream fileIn: 'Ride.st'.
FileStream fileIn: 'StandardRide.st'.
FileStream fileIn: 'PremiumRide.st'.
FileStream fileIn: 'Driver.st'.
FileStream fileIn: 'Rider.st'.

"===================================================="
"              DEMONSTRATION METHODS                 "
"===================================================="

Object subclass: RideSharingDemo [
    
    "Demonstrate polymorphism with different ride types"
    RideSharingDemo class >> demonstratePolymorphism: rides [
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   DEMONSTRATING POLYMORPHISM'; nl.
        Transcript show: '========================================'; nl.
        Transcript show: ''; nl.
        Transcript show: 'Processing different ride types polymorphically:'; nl.
        
        rides do: [:ride |
            Transcript show: ''; nl.
            Transcript show: '--- Processing Ride ID: ', ride getRideID printString, ' ---'; nl.
            "Polymorphic calls - the correct overridden methods are called"
            ride rideDetails.  "Virtual method call"
            Transcript show: 'Calculated Fare: $', ride fare printString; nl.  "Polymorphic method call"
            Transcript show: ''; nl.
        ].
    ]
    
    "Demonstrate encapsulation"
    RideSharingDemo class >> demonstrateEncapsulation [
        | driver rider |
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   DEMONSTRATING ENCAPSULATION'; nl.
        Transcript show: '========================================'; nl.
        Transcript show: ''; nl.
        Transcript show: 'Creating driver and rider with private member access control:'; nl.
        
        driver := Driver newWithID: 101 name: 'Alice Johnson' rating: 4.8.
        rider := Rider newWithID: 201 name: 'Bob Smith'.
        
        "These demonstrate encapsulation - we can only access private members through public methods"
        Transcript show: ''; nl.
        Transcript show: 'Accessing private members through public methods:'; nl.
        Transcript show: 'Driver name (via getter): ', driver getName; nl.
        Transcript show: 'Driver rating (via getter): ', driver getRating printString; nl.
        Transcript show: 'Rider name (via getter): ', rider getName; nl.
        
        "Cannot directly access driver assignedRides or rider requestedRides - they are private!"
        "We must use public methods: addRide, requestRide, getAssignedRides, etc."
    ]
    
    "Main demonstration method"
    RideSharingDemo class >> runDemo [
        | rider1 rider2 driver1 driver2 allRides ride1 ride2 ride3 ride4 standardRide premiumRide distance |
        
        Transcript show: '========================================'; nl.
        Transcript show: ' ***  RIDE SHARING APP  ***'; nl.
        Transcript show: '========================================'; nl.
        
        "Demonstrate encapsulation"
        self demonstrateEncapsulation.
        
        "Create riders and drivers"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   CREATING SYSTEM ENTITIES'; nl.
        Transcript show: '========================================'; nl.
        
        rider1 := Rider newWithID: 201 name: 'John Doe'.
        rider2 := Rider newWithID: 202 name: 'Jane Smith'.
        driver1 := Driver newWithID: 101 name: 'Mike Wilson' rating: 4.9.
        driver2 := Driver newWithID: 102 name: 'Sarah Davis' rating: 4.7.
        
        Transcript show: 'Created 2 riders and 2 drivers'; nl.
        
        "Demonstrate inheritance and polymorphism by creating different ride types"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   CREATING DIFFERENT RIDE TYPES'; nl.
        Transcript show: '========================================'; nl.
        
        "Create different types of rides using inheritance"
        allRides := OrderedCollection new.
        
        "Standard rides"
        ride1 := StandardRide newWithID: 1001 pickup: 'Downtown' dropoff: 'Airport' distance: 12.5.
        ride2 := StandardRide newWithID: 1002 pickup: 'Mall' dropoff: 'University' distance: 8.3.
        
        "Premium rides"
        ride3 := PremiumRide newWithID: 1003 pickup: 'Hotel' dropoff: 'Business District' distance: 15.0.
        ride4 := PremiumRide newWithID: 1004 pickup: 'Home' dropoff: 'Concert Hall' distance: 6.8.
        
        allRides add: ride1.
        allRides add: ride2.
        allRides add: ride3.
        allRides add: ride4.
        
        Transcript show: 'Created 2 standard rides and 2 premium rides'; nl.
        
        "Demonstrate polymorphism"
        self demonstratePolymorphism: allRides.
        
        "Simulate ride assignments and requests"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   SIMULATING RIDE OPERATIONS'; nl.
        Transcript show: '========================================'; nl.
        
        "Riders request rides"
        Transcript show: ''; nl.
        Transcript show: '--- Ride Requests ---'; nl.
        rider1 requestRide: ride1.
        rider1 requestRide: ride3.
        rider2 requestRide: ride2.
        rider2 requestRide: ride4.
        
        "Drivers get assigned rides"
        Transcript show: ''; nl.
        Transcript show: '--- Driver Assignments ---'; nl.
        driver1 addRide: ride1.
        driver1 addRide: ride2.
        driver2 addRide: ride3.
        driver2 addRide: ride4.
        
        "Display information using encapsulated methods"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   SYSTEM INFORMATION DISPLAY'; nl.
        Transcript show: '========================================'; nl.
        
        "Display rider information"
        rider1 getRiderInfo.
        rider2 getRiderInfo.
        
        "Display driver information"
        driver1 getDriverInfo.
        driver2 getDriverInfo.
        
        "Show ride histories"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   RIDE HISTORIES'; nl.
        Transcript show: '========================================'; nl.
        
        rider1 viewRides.
        driver1 displayRideHistory.
        
        "Demonstrate fare calculation differences (polymorphism)"
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   FARE COMPARISON (POLYMORPHISM)'; nl.
        Transcript show: '========================================'; nl.
        
        distance := 10.0.
        standardRide := StandardRide newWithID: 9999 pickup: 'Point A' dropoff: 'Point B' distance: distance.
        premiumRide := PremiumRide newWithID: 9998 pickup: 'Point A' dropoff: 'Point B' distance: distance.
        
        Transcript show: ''; nl.
        Transcript show: 'For the same ', distance printString, ' mile trip:'; nl.
        Transcript show: 'Standard ride fare: $', standardRide fare printString; nl.
        Transcript show: 'Premium ride fare: $', premiumRide fare printString; nl.
        Transcript show: 'Premium surcharge: $', (premiumRide fare - standardRide fare) printString; nl.
        
        Transcript show: ''; nl.
        Transcript show: '========================================'; nl.
        Transcript show: '   DEMO COMPLETED SUCCESSFULLY!'; nl.
        Transcript show: '   OOP Principles Demonstrated:'; nl.
        Transcript show: '   ✓ Encapsulation'; nl.
        Transcript show: '   ✓ Inheritance'; nl.
        Transcript show: '   ✓ Polymorphism'; nl.
        Transcript show: '========================================'; nl.
    ]
]

"===================================================="
"                 RUN THE DEMO                       "
"===================================================="

"Execute the demonstration"
RideSharingDemo runDemo.