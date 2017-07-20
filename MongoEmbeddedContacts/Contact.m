//
//  Contact.m
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize name        = _name;
@synthesize phoneNumber = _phoneNumber;
@synthesize address     = _address;
@synthesize notes       = _notes;

- (id)initWithName:(NSInteger) contactId name:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address notes:(NSString*)notes {
    if (self = [super init]) {
        self.contactId = _contactId;
        self.name = name;
        self.phoneNumber = phoneNumber;
        self.address = address;
        self.notes = notes;
    }
    return self;
}

@end
