//
//  mongo_help.h
//  EmbeddedMongoSwiftApp
//
//  Created by Tyler KAye on 7/27/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#ifndef mongo_help_h
#define mongo_help_h

#include <stdio.h>
#include "embedded_transport_layer.h"

typedef struct mongocBundle mongocBundle;

mongocBundle* mongoc_createMongocBundle(int argc,
                                 const char** argv,
                                 const char* database,
                                 const char* collection);

int64_t cheetah_c_getCollectionCount(mongocBundle* m);

void cheetah_c_insertDocument(mongocBundle* m, bson_t* bson);

mongoc_cursor_t* cheetah_c_findDocs(mongocBundle* m);

bson_t* cheetah_c_getNextDoc(mongoc_cursor_t* cursor);

char* cheetah_c_getStringValueForKey(bson_t * bson, const char * key);

bool cheetah_c_getBoolValueForKey(bson_t * bson, const char * key);

int cheetah_c_getIntValueForKey(bson_t * bson, const char * key);

bson_oid_t cheetah_c_getOidForBsonDoc(bson_t* bson);

bool cheetah_c_hasOidForBsonDoc(bson_t* bson);

void cheetah_c_deleteMongocBundle(mongocBundle* m);

char* cheetah_c_executeCommand(mongocBundle* m, const char* cmd);

void cheetah_c_removeDocWithId(bson_oid_t oid, mongocBundle* m);

char* cheetah_c_getCollectionName(mongocBundle* m);

void cheetah_c_updateDocumentWithId(mongocBundle* m, bson_oid_t oid, bson_t *new_doc);

#endif /* mongo_help_h */
