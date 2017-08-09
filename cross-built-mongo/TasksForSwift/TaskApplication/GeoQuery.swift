//
//  GeoQuery.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/8/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

func setGeoIndex(collection: Collection, name: String) throws {
    let keyDoc: BSON.Document = [
        name: "2dsphere"
    ]
    let keyB = try BSON.AutoReleasingCarrier(doc: keyDoc)
    mongoc_collection_create_index(collection.pointer, keyB.pointer, nil, nil)
}
