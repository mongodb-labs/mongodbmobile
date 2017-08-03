//
//  BSON.swift
//  BSON
//
//  Created by Alsey Coleman Miller on 12/13/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// [Binary JSON](http://bsonspec.org)
public struct BSON {
    
    public class Null {}
    
    /// BSON Array
    public typealias Array = [BSON.Value]
    
    /// BSON Document
    public typealias Document = [String: BSON.Value]
    
    /// BSON value type. 
    public enum Value: RawRepresentable, Equatable, CustomStringConvertible {
        
        case Null
        
        case Array(BSON.Array)
        
        case Document(BSON.Document)
        
        case Number(BSON.Number)
        
        case String(Swift.String)
        
        case Date(DateValue)
        
        case Timestamp(BSON.Timestamp)
        
        case Binary(BSON.Binary)
        
        case Code(BSON.Code)
        
        case ObjectID(BSON.ObjectID)
        
        case RegularExpression(BSON.RegularExpression)
        
        case MaxMinKey(BSON.Key)
    }
    
    public enum Number: Equatable {
        
        case Boolean(Bool)
        
        case Integer32(Int32)
        
        case Integer64(Int64)
        
        case Double(Swift.Double)
    }
    
    public struct Binary: Equatable {
        
        public enum Subtype: Byte {
            
            case Generic    = 0x00
            case Function   = 0x01
            case Old        = 0x02
            case UUIDOld    = 0x03
            case UUID       = 0x04
            case MD5        = 0x05
            case User       = 0x80
        }
        
        public var data: Data
        
        public var subtype: Subtype
        
        public init(data: Data, subtype: Subtype = .Generic) {
            
            self.data = data
            self.subtype = subtype
        }
    }
    
    /// Represents a string of Javascript code.
    public struct Code: Equatable {
        
        public var code: String
        
        public var scope: BSON.Document?
        
        public init(_ code: String, scope: BSON.Document? = nil) {
            
            self.code = code
            self.scope = scope
        }
    }
    
    /// BSON maximum and minimum representable types.
    public enum Key {
        
        case Minimum
        case Maximum
    }
        
    public struct Timestamp: Equatable {
        
        /// Seconds since the Unix epoch.
        public var time: UInt32
        
        /// Prdinal for operations within a given second. 
        public var oridinal: UInt32
        
        public init(time: UInt32, oridinal: UInt32) {
            
            self.time = time
            self.oridinal = oridinal
        }
    }
    
    public struct RegularExpression: Equatable {
        
        public var pattern: String
        
        public var options: String
        
        public init(_ pattern: String, options: String) {
            
            self.pattern = pattern
            self.options = options
        }
    }
}

public typealias DateValue = Date

// MARK: - RawRepresentable

public extension BSON.Value {
    
    var rawValue: Any {
        
        switch self {
            
        case .Null: return BSON.Null()
            
        case let .Array(array):
            
            let rawValues = array.map { (value) in return value.rawValue }
            
            return rawValues
            
        case let .Document(document):
            
            var rawObject: [Swift.String:Any] = [:]
            
            for (key, value) in document {
                
                rawObject[key] = value.rawValue
            }
            
            return rawObject
            
        case let .Number(number): return number.rawValue
            
        case let .Date(date): return date
            
        case let .Timestamp(timestamp): return timestamp
            
        case let .Binary(binary): return binary
            
        case let .String(string): return string
            
        case let .MaxMinKey(key): return key
            
        case let .Code(code): return code
            
        case let .ObjectID(objectID): return objectID
            
        case let .RegularExpression(regularExpression): return regularExpression
        }
    }
    
    init?(rawValue: Any) {
        
        guard (rawValue as? BSON.Null) == nil else {
            
            self = .Null
            return
        }
        
        if let key = rawValue as? BSON.Key {
            
            self = .MaxMinKey(key)
            return
        }
        
        if let string = rawValue as? Swift.String {
            
            self = .String(string)
            return
        }
        
        if let date = rawValue as? DateValue {
            
            self = .Date(date)
            return
        }
        
        if let timestamp = rawValue as? BSON.Timestamp {
            
            self = .Timestamp(timestamp)
            return
        }
        
        if let binary = rawValue as? BSON.Binary {
            
            self = .Binary(binary)
            return
        }
        
        if let number = BSON.Number(rawValue: rawValue) {
            
            self = .Number(number)
            return
        }
        
        if let rawArray = rawValue as? [Any] {
            
            var jsonArray: [BSON.Value] = []
            for val in rawArray {
                guard let json = BSON.Value(rawValue: val) else { return nil }
                jsonArray.append(json)
            }
            self = .Array(jsonArray)
            return
        }
        
        if let rawDictionary = rawValue as? [Swift.String: Any] {
            
            var document = BSON.Document()
            
            for (key, rawValue) in rawDictionary {
                
                guard let bsonValue = BSON.Value(rawValue: rawValue) else { return nil }
                
                document[key] = bsonValue
            }
            
            self = .Document(document)
            return
        }
        
        if let code = rawValue as? BSON.Code {
            
            self = .Code(code)
            return
        }
        
        if let objectID = rawValue as? BSON.ObjectID {
            
            self = .ObjectID(objectID)
            return
        }
        
        if let regularExpression = rawValue as? BSON.RegularExpression {
            
            self = .RegularExpression(regularExpression)
            return
        }
        
        return nil
    }
}

extension BSON.Value {
    public var nullValue: BSON.Null? {
        switch self {
        case .Null: return BSON.Null()
        default: return nil
        }
    }

    public var arrayValue: BSON.Array? {
        switch self {
        case .Array(let arr): return arr
        default: return nil
        }
    }

    public var documentValue: BSON.Document? {
        switch self {
        case .Document(let doc): return doc
        default: return nil
        }
    }

    public var numberValue: BSON.Number? {
        switch self {
        case .Number(let num): return num
        default: return nil
        }
    }

    public var intValue: Int? {
        guard let num = self.numberValue else { return nil }

        switch num {
        case .Integer32(let i): return Int(i)
        case .Integer64(let i): return Int(i)
        default: return nil
        }
    }

    public var doubleValue: Double? {
        guard let num = self.numberValue else { return nil }

        switch num {
        case .Double(let d): return d
        default: return nil
        }
    }

    public var boolValue: Bool? {
        guard let num = self.numberValue else { return nil }

        switch num {
        case .Boolean(let b): return b
        default: return nil
        }
    }

    public var stringValue: Swift.String? {
        switch self {
        case .String(let str): return str
        default: return nil
        }
    }

    public var dateValue: DateValue? {
        switch self {
        case .Date(let date): return date
        default: return nil
        }
    }

    public var timestampValue: BSON.Timestamp? {
        switch self {
        case .Timestamp(let stamp): return stamp
        default: return nil
        }
    }

    public var binaryValue: BSON.Binary? {
        switch self {
        case .Binary(let binary): return binary
        default: return nil
        }
    }

    public var codeValue: BSON.Code? {
        switch self {
        case .Code(let code): return code
        default: return nil
        }
    }

    public var objectIDValue: BSON.ObjectID? {
        switch self {
        case .ObjectID(let id): return id
        default: return nil
        }
    }

    public var regularExpressionValue: BSON.RegularExpression? {
        switch self {
        case .RegularExpression(let regex): return regex
        default: return nil
        }
    }

    public var keyValue: BSON.Key? {
        switch self {
        case .MaxMinKey(let key): return key
        default: return nil
        }
    }
}

public extension BSON.Number {
    
    public var rawValue: Any {
        
        switch self {
        case .Boolean(let value): return value
        case .Integer32(let value): return value
        case .Integer64(let value): return value
        case .Double(let value):  return value
        }
    }
    
    public init?(rawValue: Any) {
        
        if let value = rawValue as? Bool            { self = .Boolean(value) }
        if let value = rawValue as? Int32           { self = .Integer32(value) }
        if let value = rawValue as? Int64           { self = .Integer64(value) }
        if let value = rawValue as? Swift.Double    { self = .Double(value) }

        // use Int32 as a default - maybe check type of IntMax (Int32/Int64)?
        if let value = rawValue as? Int             { self = .Integer32(Int32(value)) }

        return nil
    }
}

// MARK: - CustomStringConvertible

public extension BSON.Value {
    
    public var description: Swift.String { return "\(rawValue)" }
}

public extension BSON.Number {
    
    public var description: Swift.String { return "\(rawValue)" }
}

// MARK: Equatable

public func ==(lhs: BSON.Value, rhs: BSON.Value) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.Null, .Null): return true
        
    case let (.String(leftValue), .String(rightValue)): return leftValue == rightValue
        
    case let (.Number(leftValue), .Number(rightValue)): return leftValue == rightValue
        
    case let (.Array(leftValue), .Array(rightValue)): return leftValue == rightValue
        
    case let (.Document(leftValue), .Document(rightValue)): return leftValue == rightValue
        
    case let (.Date(leftValue), .Date(rightValue)): return leftValue == rightValue
        
    case let (.Timestamp(leftValue), .Timestamp(rightValue)): return leftValue == rightValue
        
    case let (.Binary(leftValue), .Binary(rightValue)): return leftValue == rightValue
        
    case let (.Code(leftValue), .Code(rightValue)): return leftValue == rightValue
        
    case let (.ObjectID(leftValue), .ObjectID(rightValue)): return leftValue == rightValue
        
    case let (.RegularExpression(leftValue), .RegularExpression(rightValue)): return leftValue == rightValue
        
    case let (.MaxMinKey(leftValue), .MaxMinKey(rightValue)): return leftValue == rightValue
        
    default: return false
    }
}

public func ==(lhs: BSON.Number, rhs: BSON.Number) -> Bool {
    
    switch (lhs, rhs) {
        
    case let (.Boolean(leftValue), .Boolean(rightValue)): return leftValue == rightValue
        
    case let (.Integer32(leftValue), .Integer32(rightValue)): return leftValue == rightValue
        
    case let (.Integer64(leftValue), .Integer64(rightValue)): return leftValue == rightValue
        
    case let (.Double(leftValue), .Double(rightValue)): return leftValue == rightValue
        
    default: return false
    }
}

public func ==(lhs: BSON.Timestamp, rhs: BSON.Timestamp) -> Bool {
    
    return lhs.time == rhs.time && lhs.oridinal == rhs.oridinal
}

public func ==(lhs: BSON.Binary, rhs: BSON.Binary) -> Bool {
    
    return lhs.data == rhs.data && lhs.subtype == rhs.subtype
}

public func ==(lhs: BSON.Code, rhs: BSON.Code) -> Bool {
    
    if let leftScope = lhs.scope {
        
        guard let rightScope = rhs.scope, rightScope == leftScope
            else { return false }
    }
    
    return lhs.code == rhs.code
}

public func ==(lhs: BSON.RegularExpression, rhs: BSON.RegularExpression) -> Bool {
    
    return lhs.pattern == rhs.pattern && lhs.options == rhs.options
}

