//
//  Contact.h
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "contacts.h"
#import "mongoc.h"

@interface Contact : NSObject

@property bson_oid_t* oid;
@property (strong) NSString *name;
@property (strong) NSString *phoneNumber;
@property (strong) NSString *address;
@property (strong) NSString *notes;

- (id)initWithName:(NSInteger)contactId name:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address notes:(NSString*)notes;

+ (Contact*)createContactFromC_Contact:(c_contact*)c;
+ (c_contact*) createC_ContactFromContact:(Contact*)c;

@end

