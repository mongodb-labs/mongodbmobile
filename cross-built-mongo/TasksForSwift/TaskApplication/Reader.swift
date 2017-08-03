//
//  Reader.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//

public extension BSON {
    
    public final class Reader: IteratorProtocol {
        
        // MARK: - Private Properties
        
        private let internalPointer: UnsafeMutablePointer<bson_reader_t>
        
        // MARK: - Initialization
        
        public init(data: Data) {
            
            self.internalPointer = bson_reader_new_from_data(data.byteValue, data.byteValue.count)
        }
        
        deinit { bson_reader_destroy(internalPointer) }
        
        // MARK: - Methods
        
        public func next() -> BSON.Document? {
            
            var eof = false
            
            let valuePointer = bson_reader_read(internalPointer, &eof)
            
            guard valuePointer != nil else { return nil }
            
            // convert to document
            guard let document = BSON.documentFromUnsafePointer(documentPointer: UnsafeMutablePointer<bson_t>(mutating: valuePointer!))
                else { return nil }
            
            return document
        }
    }
}

/// Encapsulates data.
public struct Data: ByteValueType, Equatable {
    
    public var byteValue: [Byte]
    
    public init(byteValue: [Byte] = []) {
        
        self.byteValue = byteValue
    }
}

public typealias Byte = UInt8

public extension Data {
    
    /// Initializes ```Data``` from an unsafe byte pointer.
    ///
    /// - Precondition: The pointer  points to a type exactly a byte long.
    static func fromBytePointer<T: Any>(pointer: UnsafePointer<T>, length: Int) -> Data {
        
        assert(MemoryLayout<T>.size == MemoryLayout<Byte>.size, "Cannot create array of bytes from pointer to \(type(of: pointer.pointee)) because the type is larger than a single byte.")
        
        var buffer: [UInt8] = [UInt8](repeating: 0, count: length)
        
        memcpy(&buffer, pointer, length)
        
        return Data(byteValue: buffer)
    }
}

// MARK: - Equatable

public func == (lhs: Data, rhs: Data) -> Bool {
    
    guard lhs.byteValue.count == rhs.byteValue.count else { return false }
    
    var bytes1 = lhs.byteValue
    
    var bytes2 = rhs.byteValue
    
    return memcmp(&bytes1, &bytes2, lhs.byteValue.count) == 0
}


/// Stores a primitive value.
///
/// Useful for Swift wrappers for C primitives.
public protocol ByteValueType {
    
    associatedtype ByteValue
    
    /// Returns the primitive type.
    var byteValue: ByteValue { get }
    
    init(byteValue: ByteValue)
}
