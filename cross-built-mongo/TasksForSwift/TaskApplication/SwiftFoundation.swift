//
//  SwiftFoundation.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//



#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

public extension timeval {
    
    static func timeOfDay() throws -> timeval {
        
        let timeStamp = timeval()
        
        return timeStamp
    }
    
    init(timeInterval: TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = decimalValue * million
        
        self.init(tv_sec: Int(integerValue), tv_usec: POSIXMicroseconds(microseconds))
    }
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let million: TimeInterval = 1000000.0
        
        let microseconds = TimeInterval(self.tv_usec) / million
        
        return secondsSince1970 + microseconds
    }
}

public extension timespec {
    
    init(timeInterval: TimeInterval) {
        
        let (integerValue, decimalValue) = modf(timeInterval)
        
        let billion: TimeInterval = 1000000000.0
        
        let nanoseconds = decimalValue * billion
        
        self.init(tv_sec: Int(integerValue), tv_nsec: Int(nanoseconds))
    }
    
    var timeIntervalValue: TimeInterval {
        
        let secondsSince1970 = TimeInterval(self.tv_sec)
        
        let billion: TimeInterval = 1000000000.0
        
        let nanoseconds = TimeInterval(self.tv_nsec) / billion
        
        return secondsSince1970 + nanoseconds
    }
}

public extension tm {
    
    init(UTCSecondsSince1970: time_t) {
        
        var seconds = UTCSecondsSince1970
        
        let timePointer = gmtime(&seconds)
        
        self = (timePointer?.pointee)!
    }
}

// MARK: - Cross-Platform Support

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    public typealias POSIXMicroseconds = __darwin_suseconds_t
    
#elseif os(Linux)
    
    public typealias POSIXMicroseconds = __suseconds_t
    
    public func modf(value: Double) -> (Double, Double) {
        
        var integerValue: Double = 0
        
        let decimalValue = modf(value, &integerValue)
        
        return (decimalValue, integerValue)
    }
    
#endif

// Date.swift

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

/// Represents a point in time.
public struct Date: Equatable, Comparable, CustomStringConvertible {
    
    // MARK: - Properties
    
    /// The time interval between the date and the reference date (1 January 2001, GMT).
    public var timeIntervalSinceReferenceDate: TimeInterval
    
    /// The time interval between the current date and 1 January 1970, GMT.
    public var timeIntervalSince1970: TimeInterval {
        
        get { return timeIntervalSinceReferenceDate + TimeIntervalBetween1970AndReferenceDate }
        
        set { timeIntervalSinceReferenceDate = timeIntervalSince1970 - TimeIntervalBetween1970AndReferenceDate }
    }
    
    /// Returns the difference between two dates.
    public func timeIntervalSinceDate(date: Date) -> TimeInterval {
        
        return self - date
    }
    
    public var description: String {
        
        return "\(timeIntervalSinceReferenceDate)"
    }
    
    // MARK: - Initialization
    
    /// Creates the date with the current time.
    public init() {
        
        timeIntervalSinceReferenceDate = TimeIntervalSinceReferenceDate()
    }
    
    /// Creates the date with the specified time interval since the reference date (1 January 2001, GMT).
    public init(timeIntervalSinceReferenceDate timeInterval: TimeInterval) {
        
        timeIntervalSinceReferenceDate = timeInterval
    }
    
    /// Creates the date with the specified time interval since 1 January 1970, GMT.
    public init(timeIntervalSince1970 timeInterval: TimeInterval) {
        
        timeIntervalSinceReferenceDate = timeInterval - TimeIntervalBetween1970AndReferenceDate
    }
}

// MARK: - Operator Overloading

public func == (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

public func < (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func <= (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

public func >= (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

public func > (lhs: Date, rhs: Date) -> Bool {
    
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func - (lhs: Date, rhs: Date) -> TimeInterval {
    
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}

public func + (lhs: Date, rhs: TimeInterval) -> Date {
    
    return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate + rhs)
}

public func += (lhs: inout Date, rhs: TimeInterval) {
    
    lhs = lhs + rhs
}

public func - (lhs: Date, rhs: TimeInterval) -> Date {
    
    return Date(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate - rhs)
}

public func -= (lhs: inout Date, rhs: TimeInterval) {
    
    lhs = lhs - rhs
}

// MARK: - Functions

/// Returns the time interval between the current date and the reference date (1 January 2001, GMT).
public func TimeIntervalSinceReferenceDate() -> TimeInterval {
    
    return TimeIntervalSince1970() - TimeIntervalBetween1970AndReferenceDate
}

/// Returns the time interval between the current date and 1 January 1970, GMT
public func TimeIntervalSince1970() -> TimeInterval {
    
    return try! timeval.timeOfDay().timeIntervalValue
}

// MARK: - Constants

/// Time interval difference between two dates, in seconds.
public typealias TimeInterval = Double

///
/// Time interval between the Unix standard reference date of 1 January 1970 and the OpenStep reference date of 1 January 2001
/// This number comes from:
///
/// ```(((31 years * 365 days) + 8  *(days for leap years)* */) = /* total number of days */ * 24 hours * 60 minutes * 60 seconds)```
///
/// - note: This ignores leap-seconds
public let TimeIntervalBetween1970AndReferenceDate: TimeInterval = 978307200.0
