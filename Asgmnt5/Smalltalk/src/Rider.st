"===================================================="
"                 RIDER CLASS                        "
"===================================================="
"Demonstrates: Encapsulation, Data Management       "
"Private variables with controlled public access    "
"===================================================="

Object subclass: Rider [
    | riderID name requestedRides |
    
    "Constructor"
    Rider class >> newWithID: anID name: aName [
        | rider |
        rider := self new.
        rider initializeWithID: anID name: aName.
        ^rider
    ]
    
    "Instance initialization"
    initializeWithID: anID name: aName [
        riderID := anID.
        name := aName.
        requestedRides := OrderedCollection new.  "Private collection - ENCAPSULATION"
    ]
    
    "===================================================="
    "                ENCAPSULATION                       "
    "===================================================="
    "Private requestedRides accessed only through public methods"
    
    "Public method to request a ride (controlled access to private data)"
    requestRide: aRide [
        requestedRides add: aRide.
        Transcript show: 'Ride ', aRide getRideID printString, ' requested by rider ', name; nl.
    ]
    
    "Public getter methods (controlled access)"
    getRiderID [
        ^riderID
    ]
    
    getName [
        ^name
    ]
    
    getTotalRides [
        ^requestedRides size
    ]
    
    "Returns a copy to maintain encapsulation"
    getRequestedRides [
        ^requestedRides copy
    ]
    
    "Calculate total spending on all requested rides"
    calculateTotalSpending [
        | total |
        total := 0.0.
        requestedRides do: [:ride | total := total + ride fare].
        ^total
    ]
    
    "Display rider information"
    getRiderInfo [
        Transcript show: ''; nl.
        Transcript show: '=== Rider Information ==='; nl.
        Transcript show: 'Rider ID: ', riderID printString; nl.
        Transcript show: 'Name: ', name; nl.
        Transcript show: 'Total Rides Requested: ', requestedRides size printString; nl.
        Transcript show: 'Total Spending: $', self calculateTotalSpending printString; nl.
        Transcript show: '========================='; nl.
    ]
    
    "View ride history"
    viewRides [
        | counter |
        counter := 1.
        Transcript show: ''; nl.
        Transcript show: '=== Ride History for ', name, ' ==='; nl.
        requestedRides isEmpty
            ifTrue: [Transcript show: 'No rides requested yet.'; nl]
            ifFalse: [
                requestedRides do: [:ride |
                    Transcript show: ''; nl.
                    Transcript show: 'Ride ', counter printString, ':'; nl.
                    ride rideDetails.
                    counter := counter + 1.
                ]
            ].
        Transcript show: '==================================='; nl.
    ]
    
    "Display method"
    printOn: aStream [
        aStream nextPutAll: 'Rider('.
        name printOn: aStream.
        aStream nextPutAll: ', Rides: '.
        requestedRides size printOn: aStream.
        aStream nextPutAll: ', Spending: $'.
        self calculateTotalSpending printOn: aStream.
        aStream nextPutAll: ')'.
    ]
]