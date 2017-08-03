//
//  JSON.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//

import Foundation

public extension BSON {
    
    /// Converts the BSON document to JSON.
    static func toJSONString(document: BSON.Document) -> String {
        
       guard let pointer = unsafePointerFromDocument(document: document)
            else { fatalError("Could not convert document to unsafe pointer") }
        
        defer { bson_destroy(pointer) }
        
        return toJSONString(unsafePointer: pointer)
    }
    
    static func prettyPrintJson(uglyJsonString: String) -> String {
        guard let data = uglyJsonString.data(using: .utf8, allowLossyConversion: false) else { return "" }
        if let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            if let prettyData = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) {
                return String(data: prettyData, encoding: .utf8)!
            }
        }
        return "Failed"
    }
    
    /// Converts the BSON pointer to JSON.
    static func toJSONString(unsafePointer: UnsafePointer<bson_t>) -> String {
        
        var length = 0
        
        let stringBuffer = bson_as_json(unsafePointer, &length)
        
        defer { bson_free(stringBuffer) }
        
        let string = String(cString:stringBuffer!)
        
        return string
    }

    static func pointerFromJSONString(json: String) throws -> UnsafeMutablePointer<bson_t> {

        var error = bson_error_t()
        let bson = bson_new_from_json(json, -1, &error)

        return bson!
    }

    static func fromJSONString(json: String) throws -> BSON.Document {

        let bson = try BSON.pointerFromJSONString(json: json)

        let document = BSON.documentFromUnsafePointer(documentPointer: bson)

        // if bson_new_from_json succeeded, we can guarantee this works
        return document!
    }
}
