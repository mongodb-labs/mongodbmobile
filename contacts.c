#include "contacts.h"
#include <stdlib.h>
#include <string.h>
typedef struct contact {
    char* name;
    char* phoneNumber;
    char* address;
    char* notes;
} contact;

void printContact(contact * c) {
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
    libmongodbcapi_db_destroy(m->db);
    free(m);
}
void bundleSetDbCol(mongocBundle* m, const char* db, const char* collection) {
    m->col = mongoc_client_get_collection(m->client, db, collection);
}

contact* createContact(const char* name,
                       const char* phoneNumber,
                       const char* address,
                       const char* notes) {
    contact* c = (contact*)malloc(sizeof(contact));
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

    return c;
}

bson_t* createBsonFromContact(contact* c) {
    bson_t* document = BCON_NEW(
        "name", c->name, "phoneNumber", c->phoneNumber, "address", c->address, "notes", c->notes);
    return document;
}

void destroyBson(bson_t* b) {
    bson_destroy(b);
}

void destroyContact(contact* c) {
    free(c->name);
    free(c->phoneNumber);
    free(c->address);
    free(c->notes);
    free(c);
}

void insertContact(mongocBundle* m, contact* c) {
    bson_t* bson_doc = createBsonFromContact(c);
    if (!mongoc_collection_insert(m->col, MONGOC_INSERT_NONE, bson_doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Inserting: %s\n", m->error.message);
    }
    destroyBson(bson_doc);
}

void deleteContact(mongocBundle* m, contact* c) {
    bson_t* bson_doc = createBsonFromContact(c);
    if (!mongoc_collection_remove(
            m->col, MONGOC_REMOVE_SINGLE_REMOVE, bson_doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Deleting: %s\n", m->error.message);
    }
    destroyBson(bson_doc);
}

void updateContactByField(mongocBundle* m, const char* queryValue, contact* c, const char* field) {
    bson_t* query = BCON_NEW(field, queryValue);
    bson_t* doc = createBsonFromContact(c);
    if (!mongoc_collection_update(m->col, MONGOC_UPDATE_NONE, query, doc, NULL, &(m->error))) {
        // error code
        fprintf(stderr, "Error Updating: %s\n", m->error.message);
    }
    destroyBson(doc);
}

void updateContactByPhone(mongocBundle* m, const char* number, contact* c) {
    updateContactByField(m, number, c, "phoneNumber");
}

void updateContactByName(mongocBundle* m, const char* name, contact* c) {
    updateContactByField(m, name, c, "name");
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

contact* makeContactFromBson(const bson_t* doc) {
    bson_iter_t iter;
    const char* name;
    const char* number;
    const char* address;
    const char* notes;
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
            } else {
                fprintf(stderr, "INVALID FIELD %s\n", field);
                return NULL;
            }
        }
    }
    return createContact(name, number, address, notes);
}

contact* getCursorNext(mongoc_cursor_t* cursor) {
    const bson_t* doc = NULL;
    if(mongoc_cursor_next(cursor, &doc)) {
    makeContactFromBson(doc);
    return makeContactFromBson(doc);
    }
    return NULL;
}

int main() {
    contact* c1 = createContact("test", "test", "2 test rd", "");
    contact* c2 = createContact("Bob Smith", "123456789", "3 test rd", "");
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
    updateContactByPhone(m, "123456789", c2);
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