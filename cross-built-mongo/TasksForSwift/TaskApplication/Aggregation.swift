//
//  Aggregation.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/8/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

public final class Aggregation {
    
    var aggregationStages = BSON.Array()
    
    public func addStage(stage: BSON.Document) {
        aggregationStages.append(.Document(stage))
    }
    
    public func toDocument() throws -> BSON.Document {
        let pipeline: BSON.Document = [
            "pipeline": .Array(aggregationStages)
        ]
        return pipeline
    }
}

public extension Collection {
    public func aggregate(pipeline: BSON.Document, options: BSON.Document = BSON.Document()) throws -> Cursor {
        let pipeline = try BSON.AutoReleasingCarrier(doc: pipeline)
        let options = try BSON.AutoReleasingCarrier(doc: options)
        let cursorPointer = mongoc_collection_aggregate(self.pointer, MONGOC_QUERY_NONE, pipeline.pointer, options.pointer, nil)
        let cursor = Cursor(pointer: cursorPointer!)
        return cursor
    }
}

