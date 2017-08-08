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
    var latitude: Double
    var longitude: Double
    var oid: BSONObjectID
    
    init?(name: String, description: String, location: String, priority: Int, oid:BSONObjectID = BSONObjectID(), lat: Double = 0.0, lon: Double = 0.0) {
        if (name.isEmpty) {
            return nil
        }
        self.name =  name
        self.description = description
        self.location = location
        self.priority = priority
        self.oid = oid
        self.longitude = lon
        self.latitude = lat
    }

    init?(doc: BSON.Document) {
        self.name = "Sample Name"
        self.location = "Sample Location"
        self.description = "Sample Description"
        self.priority = 9
        self.latitude = 0.0
        self.longitude = 0.0
        self.oid = BSONObjectID()
        if let n = doc["name"]?.stringValue, let desc = doc["description"]?.stringValue, let loc = doc["location"]?.stringValue, let pri = doc["priority"]?.intValue, let bsonOID = doc["_id"]?.objectIDValue {
            if (n.isEmpty) {
                return nil
            }
            self.name = n
            self.description = desc
            self.location = loc
            self.priority = pri
            self.oid = bsonOID
        }
    }

    func toDocument() -> BSON.Document {
        let taskDoc: BSON.Document = [
            "name": .String(name),
            "description": .String(description),
            "location" : .String(location),
            "priority" : .Number(.Integer32(Int32(priority))),
            "geo": [
                "type": "Point",
                "coordinates": [.Number(.Double(latitude)), .Number(.Double(longitude))]
            ]
        ]
        return taskDoc
    }
    
}
