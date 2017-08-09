//
//  Collection.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//
public final class Collection {

    public let name: String
    public let databaseName: String

    let pointer: _mongoc_collection

    public init(database: Database, name: String) {
        let pointer = mongoc_database_get_collection(database.pointer, name)
        self.name = name
        self.databaseName = database.name
        self.pointer = pointer!
    }

    deinit {
        mongoc_collection_destroy(self.pointer)
    }

    public func insert(document: BSON.Document, flags: InsertFlags = .None) throws {

        let document = try BSON.AutoReleasingCarrier(doc: document)
        var error = bson_error_t()

        mongoc_collection_insert(self.pointer, flags.rawFlag, document.pointer, nil, &error)

        try error.throwIfError()
    }

    public func renameCollection(to newName: String) throws {
        var error = bson_error_t()
        mongoc_collection_rename(self.pointer, databaseName, newName, false, &error)

        try error.throwIfError()
    }
    
    public func find(query: BSON.Document = BSON.Document(), opts: BSON.Document = BSON.Document()) throws -> Cursor {
        
        let query = try BSON.AutoReleasingCarrier(doc: query)
        let opts = try BSON.AutoReleasingCarrier(doc: opts)
        
        let cursorPointer = mongoc_collection_find_with_opts(self.pointer, query.pointer, opts.pointer, nil)
        
        let cursor = Cursor(pointer: cursorPointer!)
        
        return cursor
    }
    
    public func findIndexes() throws -> [BSON.Document] {
        let cursorPointer = mongoc_collection_find_indexes(self.pointer, nil)
        let cursor = Cursor(pointer: cursorPointer!)
        let allDocs = try cursor.all()
        return allDocs
    }
    
    public func setGeoIndex(onField: String) throws {
        let keyDoc: BSON.Document = [
            name: "2dsphere"
        ]
        let keyB = try BSON.AutoReleasingCarrier(doc: keyDoc)
        mongoc_collection_create_index(self.pointer, keyB.pointer, nil, nil)
    }
    
    public func update(query: BSON.Document, newValue: BSON.Document, flags: UpdateFlags = .None) throws -> Bool {

        let query = try BSON.AutoReleasingCarrier(doc: query)
        let document = try BSON.AutoReleasingCarrier(doc: newValue)

        var error = bson_error_t()

        let success = mongoc_collection_update(
            self.pointer,
            flags.rawFlag,
            query.pointer,
            document.pointer,
            nil,
            &error
        )

        try error.throwIfError()

        return success
    }


    public func remove(query: BSON.Document = BSON.Document(), flags: RemoveFlags = .None) throws -> Bool {

        let query = try BSON.AutoReleasingCarrier(doc: query)

        var error = bson_error_t()

        let success = mongoc_collection_remove(
            self.pointer,
            flags.rawFlag,
            query.pointer,
            nil,
            &error
        )

        try error.throwIfError()

        return success
    }

    public func basicCommand(command: BSON.Document) throws -> BSON.Document {

        let command = try BSON.AutoReleasingCarrier(doc: command)

        var reply = bson_t()
        var error = bson_error_t()

        mongoc_collection_command_simple(self.pointer, command.pointer, nil, &reply, &error)

        try error.throwIfError()

        guard let res = BSON.documentFromUnsafePointer(documentPointer: &reply) else {
            throw MongoError.CorruptDocument
        }
        return res
    }

    public func destroy() {
        mongoc_collection_destroy(pointer)
    }

//    public func performCommand(command: BSON.Document, flags: QueryFlags, options: QueryOptions, fields: [String]) throws -> Cursor {
//
//        guard let fieldsJSON = fields.toJSON()?.toString() else { throw MongoError.InvalidData }
//
//        var command = try MongoBSON(data: command).bson
//        var fields = try MongoBSON(json: fieldsJSON).bson
//
//        let cursor = mongoc_collection_command(pointer, flags.rawFlag, options.skip.UInt32Value, options.limit.UInt32Value, options.batchSize.UInt32Value, &command, &fields, nil)
//
//        return Cursor(cursor: cursor)
//    }

    public func count(query: BSON.Document = BSON.Document(), flags: QueryFlags = .None, skip: Int = 0, limit: Int = 0) -> Int {
        
        do {
            let quer = try BSON.AutoReleasingCarrier(doc: query)
            var error = bson_error_t()
            
            let count = mongoc_collection_count(
                self.pointer,
                flags.rawFlag,
                quer.pointer,
                Int64(skip),
                Int64(limit),
                nil,
                &error
            )
            return Int(count)
        }
        catch {
            print("ERROR AT COUNT FUNCTION FOR COLLECTION")
            return 0;
        }
    }

    public func drop() throws {

        var error = bson_error_t()

        mongoc_collection_drop(pointer, &error)

        try error.throwIfError()
    }

    public func rename(newDatabaseName: String, newCollectionName: String, dropBeforeRename: Bool) throws -> Bool {

        var error = bson_error_t()

        let success = mongoc_collection_rename(pointer, newDatabaseName, newCollectionName, dropBeforeRename, &error)

        try error.throwIfError()

        return success
    }

    public func stats(options: BSON.Document) throws -> BSON.Document {

        let options = try BSON.AutoReleasingCarrier(doc: options)

        var reply = bson_t()
        var error = bson_error_t()

        mongoc_collection_stats(self.pointer, options.pointer, &reply, &error)

        try error.throwIfError()

        guard let res = BSON.documentFromUnsafePointer(documentPointer: &reply) else {
            throw MongoError.CorruptDocument
        }
        return res
    }
    
    

    public func validate(options: BSON.Document) throws -> BSON.Document {

        let options = try BSON.AutoReleasingCarrier(doc: options)

        var reply = bson_t()
        var error = bson_error_t()

        mongoc_collection_validate(self.pointer, options.pointer, &reply, &error)

        try error.throwIfError()

        guard let res = BSON.documentFromUnsafePointer(documentPointer: &reply) else {
            throw MongoError.CorruptDocument
        }

        return res
    }
    
    

    // TODO
    //func mongoc_collection_find_and_modify(collection: OpaquePointer, _ query: UnsafePointer<bson_t>, _ sort: UnsafePointer<bson_t>, _ update: UnsafePointer<bson_t>, _ fields: UnsafePointer<bson_t>, _ _remove: Bool, _ upsert: Bool, _ _new: Bool, _ reply: UnsafeMutablePointer<bson_t>, _ error: UnsafeMutablePointer<bson_error_t>) -> Bool
}
