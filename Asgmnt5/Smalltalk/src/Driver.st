"===================================================="
"                 DRIVER CLASS                       "
"===================================================="
"Demonstrates: Encapsulation, Data Management       "
"Private variables with controlled public access    "
"===================================================="

Object subclass: Driver [
    | driverID name rating assignedRides |
    
    "Constructor"
    Driver class >> newWithID: anID name: aName rating: aRating [
        | driver |
        driver := self new.
        driver initializeWithID: anID name: aName rating: aRating.
        ^driver
    ]
    
    "Instance initialization"
    initializeWithID: anID name: aName rating: aRating [
        driverID := anID.
        name := aName.
        rating := aRating.
        assignedRides := OrderedCollection new.  "Private collection - ENCAPSULATION"
    ]
    
    "===================================================="
    "                ENCAPSULATION                       "
    "===================================================="
    "Private assignedRides accessed only through public methods"
    
    "Public method to add a ride (controlled access to private data)"
    addRide: aRide [
        assignedRides add: aRide.
        Transcript show: 'Ride ', aRide getRideID printString, ' assigned to driver ', name; nl.
    ]
    
    "Public getter methods (controlled access)"
    getDriverID [
        ^driverID
    ]
    
    getName [
        ^name
    ]
    
    getRating [
        ^rating
    ]
    
    getTotalRides [
        ^assignedRides size
    ]
    
    "Returns a copy to maintain encapsulation"
    getAssignedRides [
        ^assignedRides copy
    ]
    
    "Public setter with validation"
    setRating: newRating [
        (newRating >= 0.0 and: [newRating <= 5.0])
            ifTrue: [rating := newRating]
            ifFalse: [Transcript show: 'Invalid rating. Must be between 0.0 and 5.0'; nl]
    ]
    
    "Calculate total earnings from all assigned rides"
    calculateTotalEarnings [
        | total |
        total := 0.0.
        assignedRides do: [:ride | total := total + ride fare].
        ^total
    ]
    
    "Display driver information"
    getDriverInfo [
        Transcript show: ''; nl.
        Transcript show: '=== Driver Information ==='; nl.
        Transcript show: 'Driver ID: ', driverID printString; nl.
        Transcript show: 'Name: ', name; nl.
        Transcript show: 'Rating: ', rating printString, '/5.0'; nl.
        Transcript show: 'Total Rides Completed: ', assignedRides size printString; nl.
        Transcript show: 'Total Earnings: $', self calculateTotalEarnings printString; nl.
        Transcript show: '========================='; nl.
    ]
    
    "Display ride history"
    displayRideHistory [
        | counter |
        counter := 1.
        Transcript show: ''; nl.
        Transcript show: '=== Ride History for ', name, ' ==='; nl.
        assignedRides isEmpty
            ifTrue: [Transcript show: 'No rides completed yet.'; nl]
            ifFalse: [
                assignedRides do: [:ride |
                    Transcript show: ''; nl.
                    Transcript show: 'Ride ', counter printString, ':'; nl.
                    ride rideDetails.
                    counter := counter + 1.
                ]
            ].
        Transcript show: '================================='; nl.
    ]
    
    "Display method"
    printOn: aStream [
        aStream nextPutAll: 'Driver('.
        name printOn: aStream.
        aStream nextPutAll: ', Rating: '.
        rating printOn: aStream.
        aStream nextPutAll: ', Rides: '.
        assignedRides size printOn: aStream.
        aStream nextPutAll: ')'.
    ]
]