//
//  Cursor.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//
public struct Cursor: IteratorProtocol, Sequence {

    private let cursor: UnsafeCursor

    init(pointer: _mongoc_cursor) {
        self.cursor = UnsafeCursor(cursor: pointer)
    }

    var lastError: MongoError {
        var error = bson_error_t()
        mongoc_cursor_error(cursor.pointer, &error)
        return error.error
    }

    public func next() -> BSON.Document? {
        guard let bson = cursor.next() else {
            return nil
        }

        return BSON.documentFromUnsafePointer(documentPointer: bson)
    }

    public func nextDocument() throws -> BSON.Document? {
        guard let next = next() else {
            return nil
        }

        if lastError.isError {
            throw lastError
        }

        return next
    }

    public func all() throws -> [BSON.Document] {

        var documents: [BSON.Document] = []

        while let document = try nextDocument() {
            documents.append(document)
        }

        return documents
    }

    public func destroy() {
        mongoc_cursor_destroy(self.cursor.pointer)
    }
}

private final class UnsafeCursor:  IteratorProtocol {
    let pointer: _mongoc_cursor

    init(cursor: _mongoc_cursor) {
        self.pointer = cursor
    }

    deinit {
        mongoc_cursor_destroy(pointer)
    }

    func next() -> UnsafePointer<bson_t>? {
        //var buffer = UnsafePointer<bson_t>(nil)
        var buffer: UnsafePointer<bson_t>? = nil

        let isOk = mongoc_cursor_next(self.pointer, &buffer)

        if isOk && buffer != nil {
            let mutableCopy = bson_copy(buffer)
            let copy = UnsafePointer<bson_t>(mutableCopy)
            return copy
        }

        return nil
    }
}
