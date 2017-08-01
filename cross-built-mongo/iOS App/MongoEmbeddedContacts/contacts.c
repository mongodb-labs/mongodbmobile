#include "contacts.h"
#include <stdlib.h>
#include <string.h>
typedef struct c_contact {
    const bson_oid_t* oid;
    char* name;
    char* phoneNumber;
    char* address;
    char* notes;
} c_contact;

const bson_oid_t* c_contact_get_oid(c_contact* c) {
    return c->oid;
}

char* c_contact_get_name(c_contact* c) {
    return c->name;
}

char* c_contact_get_phone_number(c_contact* c) {
    return c->phoneNumber;
}

char* c_contact_get_address(c_contact* c) {
    return c->address;
}

char* c_contact_get_notes(c_contact* c) {
    return c->notes;
}

void printContact(c_contact * c) {
    printf("Name: %s, phoneNumber: %s, address: %s, notes: %s\n", c->name, c->phoneNumber, c->address, c->notes);
}

typedef struct mongocBundle {
    libmongodbcapi_db* db;
    mongoc_client_t* client;
    mongoc_collection_t* col;
    bson_error_t error;
} mongocBundle;

mongocBundle* createMongocBundle(int argc,
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
    m->col = mongoc_client_get_collection(m->client, database, collection);
    if (m->db == NULL || m->client == NULL || m->col == NULL) {
        fprintf(stderr, "Found Null\n");
    }
    return m;
}

void deleteMongocBundle(mongocBundle* m) {
    mongoc_collection_destroy(m->col);
    mongoc_client_destroy(m->client);
    libmongodbcapi_db_fini(m->db);
    // libmongodbcapi_db_destroy(m->db);
    free(m);
}
void bundleSetDbCol(mongocBundle* m, const char* db, const char* collection) {
    m->col = mongoc_client_get_collection(m->client, db, collection);
}

c_contact* createContactWithOid(const char* name,
                         const char* phoneNumber,
                         const char* address,
                         const char* notes,
                         const bson_oid_t* oid) {
    c_contact* c = (c_contact*)malloc(sizeof(c_contact));
    int nameLen = strlen(name) + 1;
    c->name = (char*)malloc(nameLen);
    memcpy(c->name, name, nameLen);
    
    int phoneLen = strlen(phoneNumber) + 1;
    c->phoneNumber = (char*)malloc(phoneLen);
    memcpy(c->phoneNumber, phoneNumber, phoneLen);
    
    int addressLen = strlen(address) + 1;
    c->address = (char*)malloc(addressLen);
    memcpy(c->address, address, addressLen);
    
    int notesLen = strlen(notes) + 1;
    c->notes = (char*)malloc(notesLen);
    memcpy(c->notes, notes, notesLen);
    
    if (oid) {
        c->oid = (bson_oid_t*)malloc(sizeof(bson_oid_t));
        memcpy(c->oid, oid, sizeof(bson_oid_t));
    }
    
    return c;
}

c_contact* createContact(const char* name,
                         const char* phoneNumber,
                         const char* address,
                         const char* notes) {
//    bson_oid_t* oid = (bson_oid_t*)malloc(sizeof(bson_oid_t));
//    bson_oid_init(oid, NULL);
    c_contact* c = createContactWithOid(name, phoneNumber, address, notes, NULL);
//    free(oid);
    return c;
}

bson_t* createBsonFromContact(c_contact* c) {
    bson_t* document;
    if (c->oid) {
        document = BCON_NEW("_id", BCON_OID(c->oid),
                            "name", c->name, "phoneNumber", c->phoneNumber, "address", c->address, "notes", c->notes);
    } else {
        document = BCON_NEW(
                 "name", c->name, "phoneNumber", c->phoneNumber, "address", c->address, "notes", c->notes);
    }

    return document;
}

void destroyBson(bson_t* b) {
    bson_destroy(b);
}

void destroyContact(c_contact* c) {
    free(c->name);
    free(c->phoneNumber);
    free(c->address);
    free(c->notes);
    free(c);
}

void insertContact(mongocBundle* m, c_contact* c) {
    bson_t* bson_doc = createBsonFromContact(c);
    if (!mongoc_collection_insert(m->col, MONGOC_INSERT_NONE, bson_doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Inserting: %s\n", m->error.message);
    }
    destroyBson(bson_doc);
}

void deleteContact(mongocBundle* m, c_contact* c) {
    bson_t* bson_doc = createBsonFromContact(c);
    if (!mongoc_collection_remove(
            m->col, MONGOC_REMOVE_SINGLE_REMOVE, bson_doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Deleting: %s\n", m->error.message);
    }
    destroyBson(bson_doc);
}

void updateContactByField(mongocBundle* m, const char* queryValue, c_contact* c, const char* field) {
    bson_t* query = BCON_NEW(field, queryValue);
    bson_t* doc = createBsonFromContact(c);
    if (!mongoc_collection_update(m->col, MONGOC_UPDATE_NONE, query, doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Updating: %s\n", m->error.message);
    }
    destroyBson(doc);
}

void updateContactByOid(mongocBundle* m, const bson_oid_t* oid, c_contact* c) {
    bson_t* query = BCON_NEW("_id", BCON_OID(oid));
    bson_t* doc = createBsonFromContact(c);
    if (!mongoc_collection_update(m->col, MONGOC_UPDATE_NONE, query, doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Updating: %s\n", m->error.message);
    }
    destroyBson(doc);
}

mongoc_cursor_t* searchByField(mongocBundle* m, const char* queryValue, const char* field) {
    bson_t* query;
    if (!queryValue && !field) {
        query = bson_new();
    } else {
        query = BCON_NEW(field, queryValue);
    }
    mongoc_cursor_t* results = mongoc_collection_find_with_opts(m->col, query, NULL, NULL);
    destroyBson(query);
    return results;
}

mongoc_cursor_t* findAll(mongocBundle* m) {
    return searchByField(m, NULL, NULL);
}

mongoc_cursor_t* searchByPhone(mongocBundle* m, const char* number) {
    return searchByField(m, number, "phoneNumber");
}

mongoc_cursor_t* searchByName(mongocBundle* m, const char* name) {
    return searchByField(m, name, "name");
}

c_contact* makeContactFromBson(const bson_t* doc) {
    bson_iter_t iter;
    const char* name;
    const char* number;
    const char* address;
    const char* notes;
    const bson_oid_t* oid;
    if (bson_iter_init(&iter, doc)) {
        while (bson_iter_next(&iter)) {
            const char * field = bson_iter_key(&iter);
            if (strcmp(field, "name") == 0) {
                name = bson_iter_utf8(&iter, NULL);
            } else if (strcmp(field, "phoneNumber") == 0) {
                number = bson_iter_utf8(&iter, NULL);
            } else if (strcmp(field, "address") == 0) {
                address = bson_iter_utf8(&iter, NULL);
            } else if (strcmp(field, "notes") == 0) {
                notes = bson_iter_utf8(&iter, NULL);
            } else if (strcmp(field, "_id") == 0) {
                oid = bson_iter_oid(&iter);
            } else {
                fprintf(stderr, "INVALID FIELD %s\n", field);
                return NULL;
            }
        }
    }
    return createContactWithOid(name, number, address, notes, oid);
}

c_contact* getCursorNext(mongoc_cursor_t* cursor) {
    const bson_t* doc = NULL;
    if(mongoc_cursor_next(cursor, &doc)) {
    c_contact* toRet = makeContactFromBson(doc);
    return toRet;
    }
    mongoc_cursor_destroy(cursor);
    return NULL;
}

char* getCharCursorNext(mongoc_cursor_t* cursor) {
    const bson_t* doc = NULL;
    if(mongoc_cursor_next(cursor, &doc)) {
        char* toRet = bson_as_json(doc, NULL);
        return toRet;
    }
    mongoc_cursor_destroy(cursor);
    return NULL;
}

char * executeCollectionCommand( mongocBundle * m, const char * cmd) {
    bson_t * doc;
    doc = bson_new_from_json((const unsigned char *)cmd, -1, &(m->error));
    bson_t reply;
    char * jsonResult = NULL;
    if(mongoc_collection_command_simple(m->col, doc, NULL, &reply, &(m->error))) {
        jsonResult = bson_as_json(&reply, NULL);
        destroyBson(&reply);
    }
    destroyBson(doc);
    return jsonResult;
}

char* executeCommand(mongocBundle* m, const char* cmd) {
    bson_t reply;
    
    bson_t* command = BCON_NEW(cmd, mongoc_collection_get_name(m->col)); // m->col may have to be BCON_UTF8("contacts")
    char* str = NULL;
    if (mongoc_collection_command_simple (m->col, command, NULL, &reply, &(m->error))) {
        str = bson_as_json (&reply, NULL);
        destroyBson(&reply);
    }
    destroyBson(command);
    

    return str;
}

bool validateCommand(mongocBundle*m, char * cmd) {
    bson_t* command = bson_new_from_json(cmd, -1, &(m->error));
    if (!command) {
        return false;
    }
    size_t offset;
    bool result = bson_validate(command, BSON_VALIDATE_NONE, &offset);
    destroyBson(command);
    return result;
}

int test_main() {
    c_contact* c1 = createContact("test", "test", "2 test rd", "");
    c_contact* c2 = createContact("Bob Smith", "123456789", "3 test rd", "");
    int argc = 4;
    const char* argv[] = {"mongo_embedded_transport_layer_test",
                          "--nounixsocket",
                          "--dbpath",
                          "/home/edwardtuckman/db/data"};
    char teststr[] = {"test"};
    mongocBundle* m = createMongocBundle(argc, argv, teststr, teststr);
    mongoc_collection_drop(m->col, NULL);
    insertContact(m, c1);
    insertContact(m, c2);
    deleteContact(m, c1);
    c2->phoneNumber[0] = 78;
//    updateContactByPhone(m, "123456789", c2);
    destroyContact(c1);
    mongoc_cursor_t * cursor = findAll(m);
    while ((c1 = getCursorNext(cursor))) {
        printContact(c1);
        destroyContact(c1);
    }
    libmongodbcapi_db_pump(m->db);
    destroyContact(c2);
    deleteMongocBundle(m);
    mongoc_cleanup();
    return 0;
}
