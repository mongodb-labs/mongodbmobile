//
//  Task.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/1/17.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import Foundation

class Task {
    var name: String
    var location: String
    var description: String
    var priority: Int
    var oid: bson_oid_t
    
    init?(name: String, description: String, location: String, priority: Int) {
        if (name.isEmpty) {
            return nil
        }
        self.name =  name
        self.description = description
        self.location = location
        self.priority = priority
        self.oid = bson_oid_t()
    }
    
    init?(name: String, description: String, location: String, priority: Int, oid:bson_oid_t) {
        if (name.isEmpty) {
            return nil
        }
        self.name =  name
        self.description = description
        self.location = location
        self.priority = priority
        self.oid = oid
    }
    
    func toBson() -> UnsafeMutablePointer<bson_t> {
        let bson = bson_new()
        bson_append_utf8(bson, "name", -1, name, -1)
        bson_append_utf8(bson, "description", -1, description, -1)
        bson_append_utf8(bson, "location", -1, location, -1)
        bson_append_int32(bson, "priority", -1, Int32(priority))
        return bson!
    }
    
}
