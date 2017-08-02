//
//  mongoHelp.swift
//  EmbeddedMongoSwiftApp
//
//  Created by Tyler KAye on 7/28/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation


func cheetah_mongoInit(collName: String) -> OpaquePointer {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let args: [String?] = ["lib_mongo_embedded", "--nounixsocket", "--dbpath", documentsPath, nil]
    let argc: CInt = 4
    mongoc_init()
    
    
    // Create [UnsafePointer<Int8>]:
    var cargs = args.map { $0.flatMap { UnsafePointer<Int8>(strdup($0)) } }
    
    // Call C function:
    let db = mongoc_createMongocBundle(argc, &cargs, "embedded_mongo", collName)
    
    // Free the duplicated strings:
    for ptr in cargs { free(UnsafeMutablePointer(mutating: ptr)) }
    
    return db!
}

func cheetah_insertTask(task: Task, db: OpaquePointer) {
    let bson = task.toBson()
    cheetah_c_insertDocument(db, bson)
}

func cheetah_updateDocumentByOID(db: OpaquePointer, oid: bson_oid_t, new_doc: UnsafeMutablePointer<bson_t>) {
    cheetah_c_updateDocumentWithId(db, oid, new_doc)
}

func cheetah_getCollectionCount(db: OpaquePointer) -> Int {
    return Int(cheetah_c_getCollectionCount(db))
}

func cheetah_deleteTask(task: Task, db: OpaquePointer) {
    cheetah_c_removeDocWithId(task.oid, db)
}

func cheetah_getCollectionName(db: OpaquePointer) -> String {
    return String(cString: cheetah_c_getCollectionName(db), encoding: .utf8)!
}

func prettyPrintJson(uglyJsonString: String) -> String {
    guard let data = uglyJsonString.data(using: .utf8, allowLossyConversion: false) else { return "" }
    if let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
        if let prettyData = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) {
            return String(data: prettyData, encoding: .utf8)!
        }
    }
    return "Failed"
}

func cheetah_getCollectionStats(db: OpaquePointer) ->String {
    let s = String(cString: cheetah_c_executeCommand(db, "collStats"), encoding: .utf8)
    return prettyPrintJson(uglyJsonString: s!)
}

func cheetah_getServerStatus(db: OpaquePointer) ->String {
    let s = String(cString: cheetah_c_executeCommand(db, "serverStatus"), encoding: .utf8)
    return prettyPrintJson(uglyJsonString: s!)
}
