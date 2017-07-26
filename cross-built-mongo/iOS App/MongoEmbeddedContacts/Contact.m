//
//  Contact.m
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize oid         = _oid;
@synthesize name        = _name;
@synthesize phoneNumber = _phoneNumber;
@synthesize address     = _address;
@synthesize notes       = _notes;

- (id)initWithName:(bson_oid_t*) oid name:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address notes:(NSString*)notes {
    if (self = [super init]) {
        self.oid = oid;
        self.name = name;
        self.phoneNumber = phoneNumber;
        self.address = address;
        self.notes = notes;
    }
    return self;
}

+ (Contact*)createContactFromC_Contact:(c_contact*)c {
    NSString* name = [NSString stringWithUTF8String:c_contact_get_name(c)];
    NSString* phone_number = [NSString stringWithUTF8String:c_contact_get_phone_number(c)];
    NSString* address = [NSString stringWithUTF8String:c_contact_get_address(c)];
    NSString* notes = [NSString stringWithUTF8String:c_contact_get_notes(c)];
    Contact *c1 = [[Contact alloc] initWithName:c_contact_get_oid(c) name:name phoneNumber:phone_number  address:address notes:notes];
    destroyContact(c);
    return c1;
}

+ (c_contact*) createC_ContactFromContact:(Contact*)c {
    const char* name = [[c name] UTF8String];
    const char* pn = [[c phoneNumber] UTF8String];
    const char* address = [[c address] UTF8String];
    const char* notes = [[c notes] UTF8String];
    const bson_oid_t* oid = [c oid];
    return createContactWithOid(name, pn, address, notes, oid);
}

@end
