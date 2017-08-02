//
//  mongo_help.c
//  EmbeddedMongoSwiftApp
//
//  Created by Tyler KAye on 7/27/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#include "cheetah_c.h"

typedef struct mongocBundle {
    libmongodbcapi_db* db;
    mongoc_client_t* client;
    mongoc_collection_t* col;
    bson_error_t error;
    mongoc_database_t* cDB;
} mongocBundle;

mongocBundle* mongoc_createMongocBundle(int argc,
                                 const char** argv,
                                 const char* database,
                                 const char* collection) {
    mongocBundle* m = (mongocBundle*)malloc(sizeof(mongocBundle));
    m->db = libmongodbcapi_db_new(argc, argv, NULL);
    if (m->db == NULL) {
        fprintf(stderr,"db is NULL\n");
        return NULL;
    }
    m->client = embedded_mongoc_client_new(m->db);
    m->cDB = mongoc_client_get_database (m->client, database);
    if (mongoc_database_has_collection(m->cDB, collection, NULL)) {
        m->col = mongoc_database_get_collection(m->cDB, collection);
    }
    else {
        m->col = mongoc_database_create_collection(m->cDB, collection, NULL, NULL);
    }
    
    if (m->db == NULL || m->client == NULL || m->col == NULL) {
        fprintf(stderr, "Found Null\n");
    }
    return m;
}


void cheetah_c_deleteMongocBundle(mongocBundle* m) {
    mongoc_collection_destroy(m->col);
    mongoc_client_destroy(m->client);
    libmongodbcapi_db_destroy(m->db);
    free(m);
}


char* cheetah_c_executeCommand(mongocBundle* m, const char* cmd) {
    bson_t reply;
    
    bson_t* command = BCON_NEW(cmd, mongoc_collection_get_name(m->col)); // m->col may have to be BCON_UTF8("contacts")
    char* str = NULL;
    if (mongoc_collection_command_simple (m->col, command, NULL, &reply, &(m->error))) {
        str = bson_as_json (&reply, NULL);
    } else {
        fprintf (stderr, "Failed to run command: %s\n", m->error.message);
    }
    bson_destroy(command);
    bson_destroy(&reply);
    return str;
}

void cheetah_c_insertDocument(mongocBundle* m, bson_t* bson) {
    bson_oid_t oid;
    bson_oid_init(&oid, NULL);
    
    if(!cheetah_c_hasOidForBsonDoc(bson)) {
        bson_append_oid(bson, "_id", -1, &oid);
    }

    if (!mongoc_collection_insert(m->col, MONGOC_INSERT_NONE, bson, NULL, &(m->error)))  {
         fprintf(stderr, "Error Inserting: %s\n", m->error.message);
    }
    printf("NAME FOR INSERTED TASK: %s \n", cheetah_c_getStringValueForKey(bson, "name"));
}

char* cheetah_c_getStringValueForKey(bson_t * bson, const char * key) {
    bson_iter_t iter;
    if (bson_iter_init_find(&iter, bson, key)) {
        bson_value_t* val = bson_iter_value(&iter);
        bson_type_t type = bson_iter_type(&iter);
        if(type == BSON_TYPE_UTF8) {
            return val->value.v_utf8.str;
        }
    }
    return NULL;
}

bool cheetah_c_getBoolValueForKey(bson_t * bson, const char * key) {
    bson_iter_t iter;
    if (bson_iter_init_find(&iter, bson, key)) {
        bson_value_t* val = bson_iter_value(&iter);
        bson_type_t type = bson_iter_type(&iter);
        if(type == BSON_TYPE_BOOL) {
            return val->value.v_bool;
        }
    }
    return NULL;
}

int cheetah_c_getIntValueForKey(bson_t * bson, const char * key) {
    bson_iter_t iter;
    if (bson_iter_init_find(&iter, bson, key)) {
        bson_value_t* val = bson_iter_value(&iter);
        bson_type_t type = bson_iter_type(&iter);
        if(type == BSON_TYPE_INT32) {
            return val->value.v_int32;
        }
        if(type == BSON_TYPE_INT64) {
            return val->value.v_int64;
        }
    }
    return NULL;
}

bson_oid_t cheetah_c_getOidForBsonDoc(bson_t* bson) {
    bson_iter_t iter;
    bson_oid_t oid;
    char* retStr;
    if (bson_iter_init_find(&iter, bson, "_id")) {
        bson_value_t* val = bson_iter_value(&iter);
        bson_type_t type = bson_iter_type(&iter);
        if(type == BSON_TYPE_OID) {
            return val->value.v_oid;
        }
    }
    return oid;
}

bool cheetah_c_hasOidForBsonDoc(bson_t* bson) {
    bson_iter_t iter;
    char* retStr;
    if (bson_iter_init_find(&iter, bson, "_id")) {
        bson_value_t* val = bson_iter_value(&iter);
        bson_type_t type = bson_iter_type(&iter);
        if(type == BSON_TYPE_OID) {
            return true;
        }
    }
    return false;
}

mongoc_cursor_t* cheetah_c_findDocs(mongocBundle* m) {
    mongoc_collection_t *collection = m->col;
    mongoc_cursor_t *cursor;
    const bson_t *doc;
    bson_t *query = bson_new();
    
    cursor = mongoc_collection_find_with_opts (collection, query, NULL, NULL);
    return cursor;
}

bson_t* cheetah_c_getNextDoc(mongoc_cursor_t* cursor) {
    const bson_t *doc;
    while (mongoc_cursor_next (cursor, &doc)) {
        return doc;
    }
    return NULL;
}

int64_t cheetah_c_getCollectionCount(mongocBundle* m) {
    bson_t* query = bson_new();
    bson_error_t error;
    return mongoc_collection_count(m->col, MONGOC_QUERY_NONE, query, 0, 0, NULL, &error);
}

void cheetah_c_removeDocWithId(bson_oid_t oid, mongocBundle* m) {
    bson_error_t error;
    bson_t *doc = bson_new();
    bson_append_oid(doc, "_id", -1, &oid);
    if (!mongoc_collection_remove (m->col, MONGOC_REMOVE_SINGLE_REMOVE, doc, NULL, &error)) {
        printf ("Delete failed: %s\n", error.message);
    }
    bson_destroy (doc);
}

char* cheetah_c_getCollectionName(mongocBundle* m) {
    return mongoc_collection_get_name(m->col);
}

void cheetah_c_updateDocumentWithId(mongocBundle* m, bson_oid_t oid, bson_t *new_doc) {
    bson_error_t error;
    bson_t *old_doc = bson_new();
    bson_append_oid(old_doc, "_id", -1, &oid);
    
    if (!cheetah_c_hasOidForBsonDoc(new_doc)) {
        bson_append_oid(new_doc, "_id", -1, &oid);
    }
    
    if (!mongoc_collection_update(m->col, MONGOC_UPDATE_NONE, old_doc, new_doc, NULL, &error)) {
        printf ("Delete failed: %s\n", error.message);
    }
    bson_destroy(old_doc);
    
}








