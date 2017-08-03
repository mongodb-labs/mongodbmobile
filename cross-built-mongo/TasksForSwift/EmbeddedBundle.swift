//
//  EmbeddedBundle.swift
//  Cheetah Swift Driver
//
//  Created by Tyler Kaye on 8/2/17.
//
import Foundation

public final class EmbeddedBundle {
    
    var embeddedDB: OpaquePointer
    var mongoDB: Database
    var mongoClient: Client
    var mongoCollection: Collection
    
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
        
        // create the client
        mongoClient = Client(client: embedded_mongoc_client_new(embeddedDB))
        
        // create the database
        mongoDB = Database(client: mongoClient, name: databaseName)
        
        // create the collection
        mongoCollection = Collection(database: mongoDB, name: collectionName)
    }

    deinit {
        libmongodbcapi_db_fini(embeddedDB)
        mongoc_cleanup()
    }
}
