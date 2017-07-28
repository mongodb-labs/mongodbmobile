#include "embedded_transport_layer.h"
typedef struct c_contact c_contact;

typedef struct mongocBundle mongocBundle;

const bson_oid_t* c_contact_get_oid(c_contact*);
char* c_contact_get_name(c_contact*);
char* c_contact_get_phone_number(c_contact*);
char* c_contact_get_address(c_contact*);
char* c_contact_get_notes(c_contact*);

mongocBundle* createMongocBundle(int argc,
                                 const char** argv,
                                 const char* database,
                                 const char* collection);

void deleteMongocBundle(mongocBundle* m);

void bundleSetDbCol(mongocBundle* m, const char* db, const char* collection);

c_contact* createContactWithOid(const char* name,
                     const char* phoneNumber,
                     const char* address,
                     const char* notes,
                     const bson_oid_t* oid);

c_contact* createContact(const char* name,
                       const char* phoneNumber,
                       const char* address,
                       const char* notes);

void destroyContact(c_contact* c);

void insertContact(mongocBundle* m, c_contact* c);

void deleteContact(mongocBundle* m, c_contact* c);

void updateContactByOid(mongocBundle* m, const bson_oid_t* oid, c_contact* c);

mongoc_cursor_t* findAll(mongocBundle* m);

mongoc_cursor_t* searchByPhone(mongocBundle* m, const char* number);

mongoc_cursor_t* searchByName(mongocBundle* m, const char* name);

c_contact* getCursorNext(mongoc_cursor_t* cursor);

char * getCharCursorNext(mongoc_cursor_t * cursor);

char* executeCommand(mongocBundle*, const char*);

bson_t * executeCollectionCommand(mongocBundle *, const char *);
