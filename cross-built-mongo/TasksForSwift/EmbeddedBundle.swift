//
//  EmbeddedBundle.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//
import Foundation

public final class EmbeddedBundle {
    
    var embeddedDB: OpaquePointer
    var mongocDB: OpaquePointer
    var mongocClient: OpaquePointer
    var mongocCollection: OpaquePointer
    
    public init(databaseName: String, collectionName: String) {
        // call mongoc_init()
        mongoc_init()
        
        // Get the arguments for the embedded db new
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let args: [String?] = ["lib_mongo_embedded", "--nounixsocket", "--dbpath", documentsPath, nil]
        let argc: CInt = 4
        var cargs = args.map { $0.flatMap { UnsafePointer<Int8>(strdup($0)) } }
        
        // create the embedded db from CAPI
        embeddedDB = libmongodbcapi_db_new(argc, &cargs, nil)
        
        // create the mongoc client 
        mongocClient = embedded_mongoc_client_new(embeddedDB)
        
        // create the mongoc database 
        mongocDB = mongoc_client_get_database(mongocClient, databaseName)
        
        // create the mongoc collection
        if (mongoc_database_has_collection(mongocDB, collectionName, nil)) {
            mongocCollection = mongoc_database_get_collection(mongocDB, collectionName)
        } else {
            mongocCollection = mongoc_database_create_collection(mongocDB, collectionName, nil, nil)
        }
    }

    deinit {
        mongoc_collection_destroy (mongocCollection)
        mongoc_client_destroy (mongocClient)
        mongoc_database_destroy(mongocDB)
        libmongodbcapi_db_fini(embeddedDB)
        mongoc_cleanup()
    }
}
