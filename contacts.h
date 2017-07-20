#include "embedded_transport_layer.h"
typedef struct contact contact;

typedef struct mongocBundle mongocBundle;

mongocBundle* createMongocBundle(int argc,
                                 const char** argv,
                                 const char* database,
                                 const char* collection);

void deleteMongocBundle(mongocBundle* m);

void bundleSetDbCol(mongocBundle* m, const char* db, const char* collection);

contact* createContact(const char* name,
                       const char* phoneNumber,
                       const char* address,
                       const char* notes);

void destroyContact(contact* c);

void insertContact(mongocBundle* m, contact* c);

void deleteContact(mongocBundle* m, contact* c);

void updateContactByPhone(mongocBundle* m, const char* number, contact* c);

void updateContactByName(mongocBundle* m, const char* name, contact* c);

mongoc_cursor_t* findAll(mongocBundle* m);

mongoc_cursor_t* searchByPhone(mongocBundle* m, const char* number);

mongoc_cursor_t* searchByName(mongocBundle* m, const char* name);

contact* getCursorNext(mongoc_cursor_t* cursor);
